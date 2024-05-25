

using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Product;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductService : ICRUDService<Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest, long>
    {
        Task<Product> Activate(long id);

        Task<Product> Hide(long id);

        Task<List<string>> AllowedActions(long id);
    }
}
