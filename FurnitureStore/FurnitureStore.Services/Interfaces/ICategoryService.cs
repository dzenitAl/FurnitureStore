
namespace FurnitureStore.Services.Interfaces
{
    public interface ICategoryService :ICRUDService<Models.Category.Category, Models.SearchObjects.CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest,  long>
    {
    }
}
