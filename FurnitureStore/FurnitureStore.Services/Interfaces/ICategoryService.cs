using Microsoft.AspNetCore.Http;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services
{
    public interface ICategoryService : 
        ICRUDService<Models.Category.Category, Models.SearchObjects.CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest, long>,
        IBaseImageHandlingService<Models.Category.Category, long>
    {
    }
}
