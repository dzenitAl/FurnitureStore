
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Subcategory;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Interfaces
{
    public interface ISubcategoryService :
        ICRUDService<Subcategory, SubcategorySearchObject, SubcategoryRequest, SubcategoryRequest, long>,
        IBaseImageHandlingService<Models.Subcategory.Subcategory, long>
    {
    }
}
