
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Subcategory;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Interfaces
{
    public interface ISubcategoryService : ICRUDService<Subcategory, SubcategorySearchObject, SubcategoryRequest, SubcategoryRequest, long>
    {
        Task<Models.Subcategory.Subcategory> UpdateImage(long id, IFormFile file);
        Task<bool> DeleteImage(long id);
    }
}
