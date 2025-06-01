using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using FurnitureStore.Services;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : BaseImageHandlingController<
        Models.Category.Category,
        Models.SearchObjects.CategorySearchObject,
        Models.Category.CategoryRequest,
        Models.Category.CategoryRequest,
        long>
    {
        public CategoryController(
    ILogger<BaseImageHandlingController<Models.Category.Category, Models.SearchObjects.CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest, long>> logger,
    ICategoryService service)
    : base(logger, service, service)
        {
        }

    }

}
