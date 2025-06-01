using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductPicture;
using Microsoft.AspNetCore.Http;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductPictureService : 
        IBaseImageHandlingService<ProductPicture, long>,
        ICRUDService<ProductPicture, BaseSearchObject, ProductPictureInsertRequest, ProductPictureUpdateRequest, long>
    {
        Task<ProductPicture> AddProductPictureAsync(long productId, IFormFile imageFile);
        Task<List<ProductPicture>> GetProductPicturesAsync(long productId);
        Task<ProductPicture> GetProductPictureById(long id);
        Task<ProductPicture> GetByEntityAsync(string entityType, long entityId);
        Task<ProductPicture> AddEntityImageAsync(string entityType, long entityId, IFormFile file);
        Task<bool> DeleteEntityImageAsync(string entityType, long entityId);
        
        Task<string> GetEntityImagePathAsync(string entityType, long entityId);
        Task<bool> HasEntityImageAsync(string entityType, long entityId);
        Task<Dictionary<long, string>> GetEntityImagesPathsAsync(string entityType, IEnumerable<long> entityIds);
    }
}

