

using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Product;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductService : ICRUDService<Product, ProductSearchObject, ProductInsertRequest, ProductUpdateRequest, long>
    {
        List<Product> Recommend(long id);
    }
}
