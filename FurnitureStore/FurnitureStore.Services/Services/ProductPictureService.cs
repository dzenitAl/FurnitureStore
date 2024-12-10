using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using System.IO;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace FurnitureStore.Services.Services
{
    public class ProductPictureService : BaseCRUDService<Models.ProductPicture.ProductPicture, ProductPicture, BaseSearchObject,
        Models.ProductPicture.ProductPictureInsertRequest, Models.ProductPicture.ProductPictureUpdateRequest, long>, IProductPictureService
    {
        private readonly IMapper _mapper;

        public ProductPictureService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
            _mapper = mapper;
        }

        public async Task<Models.ProductPicture.ProductPicture> AddProductPictureAsync(long productId, IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
                throw new ArgumentException("No image file provided.");

            var imagesFolderPath = Path.Combine(Directory.GetCurrentDirectory(), "/images");
            if (!Directory.Exists(imagesFolderPath))
            {
                Directory.CreateDirectory(imagesFolderPath); 
            }

            var uniqueFileName = $"{Guid.NewGuid()}_{imageFile.FileName}";
            var filePath = Path.Combine(imagesFolderPath, uniqueFileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(stream);
            }

            var productPictureEntity = new FurnitureStore.Services.Database.ProductPicture
            {
                ProductId = productId,
                ImagePath = $"/images/{uniqueFileName}" 
            };

            _context.ProductPictures.Add(productPictureEntity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Models.ProductPicture.ProductPicture>(productPictureEntity);
        }
    }
}
