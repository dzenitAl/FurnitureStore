using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : BaseCRUDController<Models.Category.Category, Models.SearchObjects.CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest, long>
    {
        public CategoryController(ILogger<BaseController<Models.Category.Category, Models.SearchObjects.CategorySearchObject, long>> logger, ICategoryService service) : base(logger, service)
        {
        }
    } 

}
