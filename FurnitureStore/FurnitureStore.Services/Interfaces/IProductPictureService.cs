using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductPicture;


namespace FurnitureStore.Services.Interfaces
{
    public interface IProductPictureService : ICRUDService<ProductPicture, BaseSearchObject, ProductPictureInsertRequest, ProductPictureUpdateRequest, long >
    {
    }
}
