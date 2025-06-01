using AutoMapper;
using FurnitureStore.Models.ProductPicture;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace FurnitureStore.Services.Services
{
     public class ProductPictureService : 
        BaseCRUDService<Models.ProductPicture.ProductPicture, Database.ProductPicture, BaseSearchObject,
            ProductPictureInsertRequest, ProductPictureUpdateRequest, long>,
        IProductPictureService
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly ILogger<ProductPictureService> _logger;
        private readonly string _imagesDirectory;

        public ProductPictureService(
            AppDbContext context,
            IMapper mapper,
            IWebHostEnvironment webHostEnvironment,
            ILogger<ProductPictureService> logger) : base(context, mapper)
        {
            _webHostEnvironment = webHostEnvironment;
            _logger = logger;
            _imagesDirectory = Path.Combine(_webHostEnvironment.WebRootPath, "images");
            
            if (!Directory.Exists(_imagesDirectory))
            {
                Directory.CreateDirectory(_imagesDirectory);
                _logger.LogInformation($"Created images directory at: {_imagesDirectory}");
            }
        }

        public async Task<Models.ProductPicture.ProductPicture> GetProductPictureById(long id)
        {
            var picture = await _context.ProductPictures.FirstOrDefaultAsync(p => p.Id == id);
            
            if (picture == null)
            {
                throw new ArgumentException($"Product picture with ID {id} not found");
            }
            
            return _mapper.Map<Models.ProductPicture.ProductPicture>(picture);
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

                var productPicture = new Database.ProductPicture
                {
                    ProductId = productId,
                    EntityId = productId,
                    EntityType = "Product",
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

        public async Task<List<Models.ProductPicture.ProductPicture>> GetProductPicturesAsync(long productId)
        {
            try
            {
                Console.WriteLine($"Getting pictures for product ID: {productId}");
                var pictures = await _context.ProductPictures
                    .Where(pp => pp.ProductId == productId)
                    .ToListAsync();

                Console.WriteLine($"Found {pictures.Count} pictures");
                foreach (var pic in pictures)
                {
                    Console.WriteLine($"Picture ID: {pic.Id}, Path: {pic.ImagePath}");
                }

                return _mapper.Map<List<Models.ProductPicture.ProductPicture>>(pictures);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error getting product pictures: {ex.Message}");
                throw;
            }
        }

        public async Task<Models.ProductPicture.ProductPicture> GetByEntityAsync(string entityType, long entityId)
        {
            var picture = await _context.ProductPictures
                .FirstOrDefaultAsync(p => p.EntityType == entityType && p.EntityId == entityId);
            return _mapper.Map<Models.ProductPicture.ProductPicture>(picture);
        }

        public async Task<Models.ProductPicture.ProductPicture> AddEntityImageAsync(string entityType, long entityId, IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                throw new ArgumentException("No image file provided");
            }

            string extension = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (!new[] { ".jpg", ".jpeg", ".png", ".gif" }.Contains(extension))
            {
                throw new ArgumentException("Invalid file type. Only .jpg, .jpeg, .png, and .gif files are allowed.");
            }

            var existing = await GetByEntityAsync(entityType, entityId);
            if (existing != null)
            {
                await DeleteImage(existing.Id);
            }

            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            string uniqueFileName = $"{entityType}_{entityId}_{timestamp}_{Guid.NewGuid().ToString().Substring(0, 8)}{extension}";
            string filePath = Path.Combine(_imagesDirectory, uniqueFileName);

            try
            {
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }
                _logger.LogInformation($"File saved successfully to: {filePath}");

                var productPicture = new Database.ProductPicture
                {
                    EntityType = entityType,
                    EntityId = entityId,
                    ImagePath = $"/images/{uniqueFileName}"
                };

                _context.ProductPictures.Add(productPicture);
                await _context.SaveChangesAsync();

                return _mapper.Map<Models.ProductPicture.ProductPicture>(productPicture);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error saving file: {ex.Message}");
                if (File.Exists(filePath))
                {
                    try
                    {
                        File.Delete(filePath);
                    }
                    catch
                    {
                        _logger.LogWarning($"Failed to clean up file after error: {filePath}");
                    }
                }
                throw new Exception($"Failed to save image file: {ex.Message}", ex);
            }
        }

        public async Task<bool> DeleteEntityImageAsync(string entityType, long entityId)
        {
            var picture = await GetByEntityAsync(entityType, entityId);
            if (picture == null)
                return false;

            try
            {
                await DeleteImage(picture.Id);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<Models.ProductPicture.ProductPicture> UpdateImage(long id, IFormFile file)
        {
            var picture = await _context.ProductPictures.FindAsync(id);
            if (picture == null)
                throw new ArgumentException($"Picture with ID {id} not found");

            if (file == null || file.Length == 0)
                throw new ArgumentException("No image file provided");

            if (!string.IsNullOrEmpty(picture.ImagePath))
            {
                var oldFilePath = Path.Combine(_webHostEnvironment.WebRootPath, picture.ImagePath.TrimStart('/'));
                if (File.Exists(oldFilePath))
                {
                    try
                    {
                        File.Delete(oldFilePath);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError($"Failed to delete old file {oldFilePath}: {ex.Message}");
                    }
                }
            }

            string extension = Path.GetExtension(file.FileName).ToLowerInvariant();
            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            string uniqueFileName = $"{timestamp}_{Guid.NewGuid().ToString().Substring(0, 8)}{extension}";
            string filePath = Path.Combine(_imagesDirectory, uniqueFileName);

            try
            {
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }

                picture.ImagePath = $"/images/{uniqueFileName}";
                await _context.SaveChangesAsync();

                return _mapper.Map<Models.ProductPicture.ProductPicture>(picture);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error updating image: {ex.Message}");
                throw new Exception($"Failed to update image: {ex.Message}", ex);
            }
        }

        public async Task<bool> DeleteImage(long id)
        {
            var picture = await _context.ProductPictures.FindAsync(id);
            if (picture == null)
                return false;

            try
            {
                if (!string.IsNullOrEmpty(picture.ImagePath))
                {
                    var filePath = Path.Combine(_webHostEnvironment.WebRootPath, picture.ImagePath.TrimStart('/'));
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                _context.ProductPictures.Remove(picture);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error deleting image: {ex.Message}");
                return false;
            }
        }

        public async Task<string> GetEntityImagePathAsync(string entityType, long entityId)
        {
            var picture = await GetByEntityAsync(entityType, entityId);
            return picture?.ImagePath;
        }

        public async Task<bool> HasEntityImageAsync(string entityType, long entityId)
        {
            var picture = await GetByEntityAsync(entityType, entityId);
            return picture != null;
        }

        public async Task<Dictionary<long, string>> GetEntityImagesPathsAsync(string entityType, IEnumerable<long> entityIds)
        {
            var pictures = await _context.ProductPictures
                .Where(p => p.EntityType == entityType && entityIds.Contains(p.EntityId))
                .ToDictionaryAsync(p => p.EntityId, p => p.ImagePath);
            
            return pictures;
        }

        public override async Task Delete(long id)
        {
            var picture = await _context.ProductPictures.FindAsync(id);
            if (picture != null && !string.IsNullOrEmpty(picture.ImagePath))
            {
                var filePath = Path.Combine(_webHostEnvironment.WebRootPath, picture.ImagePath.TrimStart('/'));
                if (File.Exists(filePath))
                {
                    try
                    {
                        File.Delete(filePath);
                        _logger.LogInformation($"Deleted physical file: {filePath}");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError($"Failed to delete physical file {filePath}: {ex.Message}");
                    }
                }
            }

            await base.Delete(id);
        }

        public async Task<Models.ProductPicture.ProductPicture> AddImage(long id, IFormFile file)
        {
            var entity = await _context.ProductPictures.FindAsync(id);
            if (entity == null)
                return null;

            return await UpdateImage(id, file);
        }
    }
}
