using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SubcategoryController : BaseImageHandlingController<
        Models.Subcategory.Subcategory,
        SubcategorySearchObject,
        Models.Subcategory.SubcategoryRequest,
        Models.Subcategory.SubcategoryRequest,
        long>
    {
        public SubcategoryController(
            ILogger<BaseImageHandlingController<Models.Subcategory.Subcategory, SubcategorySearchObject, Models.Subcategory.SubcategoryRequest, Models.Subcategory.SubcategoryRequest, long>> logger,
            ISubcategoryService service)
            : base(logger, service, service)
        {
        }
    }
}
