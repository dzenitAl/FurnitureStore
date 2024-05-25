
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Subcategory;

namespace FurnitureStore.Services.Interfaces
{
    public interface ISubcategoryService : ICRUDService<Subcategory, SubcategorySearchObject, SubcategoryRequest, SubcategoryRequest, long>
    {
    }
}
