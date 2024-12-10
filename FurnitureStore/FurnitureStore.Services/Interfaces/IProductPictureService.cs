using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductPicture;
using Microsoft.AspNetCore.Http;
using FurnitureStore.Services.Interfaces;


namespace FurnitureStore.Services.Interfaces
{
  
    public interface IProductPictureService : ICRUDService<ProductPicture, BaseSearchObject, ProductPictureInsertRequest, ProductPictureUpdateRequest, long>
    {
        Task<ProductPicture> AddProductPictureAsync(long productId, IFormFile imageFile);
    }

}

