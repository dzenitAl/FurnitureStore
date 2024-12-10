using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : BaseCRUDController<Models.Product.Product, ProductSearchObject,
        Models.Product.ProductInsertRequest, Models.Product.ProductUpdateRequest, long>
    {
        public ProductController(ILogger<BaseController<Models.Product.Product, ProductSearchObject, long>> logger, IProductService service) : base(logger, service)
        {

        }
       
    }
}
