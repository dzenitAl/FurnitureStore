using AutoMapper;
using FurnitureStore.Models.Product;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace FurnitureStore.Services.Services
{
    public class ProductService : BaseCRUDService<Models.Product.Product, Database.Product, ProductSearchObject,
        ProductInsertRequest, ProductUpdateRequest, long>, IProductService
    {
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        private readonly ILogger<ProductService> _logger;
        private readonly string _imagesDirectory;

        public ProductService(AppDbContext context, IMapper mapper, ILogger<ProductService> logger, string imagesDirectory) : base(context, mapper)
        {
            _logger = logger;
            _imagesDirectory = imagesDirectory;
        }

        public override IQueryable<Database.Product> AddFilter(IQueryable<Database.Product> query, ProductSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.StartsWith(search.Name));
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Product> AddInclude(IQueryable<Database.Product> query, ProductSearchObject? search = null)
        {
            query = query.Include(p => p.ProductPictures);
            return base.AddInclude(query, search);
        }

        public List<Models.Product.Product> Recommend(long id)
        {
            try
            {
                lock (isLocked)
                {
                    if (mlContext == null)
                    {
                        mlContext = new MLContext();

                        var tmpData = _context.Orders.Include("OrderItems").ToList();

                        if (tmpData.Count == 0 || !tmpData.Any(x => x.OrderItems.Count > 1))
                        {
                            var product = _context.Products.Find(id);
                            if (product != null)
                            {
                                var similarProducts = _context.Products
                                    .Where(x => x.SubcategoryId == product.SubcategoryId && x.Id != id)
                                    .Take(3)
                                    .ToList();
                                return _mapper.Map<List<Models.Product.Product>>(similarProducts);
                            }
                            return new List<Models.Product.Product>();
                        }

                        var data = new List<ProductEntry>();

                        foreach (var x in tmpData)
                        {
                            if (x.OrderItems.Count > 1)
                            {
                                var distinctItemId = x.OrderItems.Select(y => y.ProductId).ToList();

                                distinctItemId.ForEach(y =>
                                {
                                    var relatedItems = x.OrderItems.Where(z => z.ProductId != y);

                                    foreach (var z in relatedItems)
                                    {
                                        data.Add(new ProductEntry()
                                        {
                                            ProductID = (uint)y,
                                            CoPurchaseProductID = (uint)z.ProductId,
                                        });
                                    }
                                });
                            }
                        }

                        if (data.Count == 0)
                        {
                            var product = _context.Products.Find(id);
                            if (product != null)
                            {
                                var similarProducts = _context.Products
                                    .Where(x => x.SubcategoryId == product.SubcategoryId && x.Id != id)
                                    .Take(3)
                                    .ToList();
                                return _mapper.Map<List<Models.Product.Product>>(similarProducts);
                            }
                            return new List<Models.Product.Product>();
                        }

                        var traindata = mlContext.Data.LoadFromEnumerable(data);

                        MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                        options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                        options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                        options.LabelColumnName = "Label";
                        options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                        options.Alpha = 0.01;
                        options.Lambda = 0.025;
                        options.NumberOfIterations = 100;
                        options.C = 0.00001;

                        var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                        model = est.Fit(traindata);
                    }
                }

                var products = _context.Products.Where(x => x.Id != id).ToList();
                if (!products.Any())
                {
                    return new List<Models.Product.Product>();
                }

                var predictionResult = new List<Tuple<Database.Product, float>>();

                foreach (var product in products)
                {
                    try
                    {
                        var predictionengine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                        var prediction = predictionengine.Predict(
                            new ProductEntry()
                            {
                                ProductID = (uint)id,
                                CoPurchaseProductID = (uint)product.Id
                            });

                        predictionResult.Add(new Tuple<Database.Product, float>(product, prediction.Score));
                    }
                    catch
                    {
                        continue;
                    }
                }

                var finalResult = predictionResult
                    .OrderByDescending(x => x.Item2)
                    .Select(x => x.Item1)
                    .Take(3)
                    .ToList();

                if (finalResult.Count < 3)
                {
                    var product = _context.Products.Find(id);
                    if (product != null)
                    {
                        var additionalProducts = _context.Products
                            .Where(x => x.SubcategoryId == product.SubcategoryId && x.Id != id && !finalResult.Any(r => r.Id == x.Id))
                            .Take(3 - finalResult.Count)
                            .ToList();
                        finalResult.AddRange(additionalProducts);
                    }
                }

                return _mapper.Map<List<Models.Product.Product>>(finalResult);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in Recommend method: {ex.Message}");
                
                var product = _context.Products.Find(id);
                if (product != null)
                {
                    var similarProducts = _context.Products
                        .Where(x => x.SubcategoryId == product.SubcategoryId && x.Id != id)
                        .Take(3)
                        .ToList();
                    return _mapper.Map<List<Models.Product.Product>>(similarProducts);
                }
                return new List<Models.Product.Product>();
            }
        }

        public async Task<Models.ProductPicture.ProductPicture> AddProductPictureAsync(long productId, IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
            {
                throw new ArgumentException("No image file provided");
            }

            var product = await _context.Products.FindAsync(productId);
            if (product == null)
            {
                throw new ArgumentException($"Product with ID {productId} not found");
            }

            string extension = Path.GetExtension(imageFile.FileName).ToLowerInvariant();
            if (!new[] { ".jpg", ".jpeg", ".png", ".gif" }.Contains(extension))
            {
                throw new ArgumentException("Invalid file type. Only .jpg, .jpeg, .png, and .gif files are allowed.");
            }

            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            string uniqueFileName = $"{timestamp}_{Guid.NewGuid().ToString().Substring(0, 8)}{extension}";
            string filePath = Path.Combine(_imagesDirectory, uniqueFileName);

            try
            {
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await imageFile.CopyToAsync(fileStream);
                }
                _logger.LogInformation($"File saved successfully to: {filePath}");

                var productPicture = new ProductPicture
                {
                    ProductId = productId,
                    ImagePath = $"/images/{uniqueFileName}"
                };

                _context.ProductPictures.Add(productPicture);
                await _context.SaveChangesAsync();

                return _mapper.Map<Models.ProductPicture.ProductPicture>(productPicture);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error saving file: {ex.Message}");
                throw new Exception($"Failed to save image file: {ex.Message}", ex);
            }
        }
    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 10)]
        public uint ProductID { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    

}


}
