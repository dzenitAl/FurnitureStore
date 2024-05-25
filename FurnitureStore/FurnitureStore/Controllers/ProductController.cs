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
        [HttpPut("{id}/activate")]
        public virtual async Task<Models.Product.Product> Activate(long id)
        {
            return await (_service as IProductService).Activate(id);
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Models.Product.Product> Hide(long id)
        {
            return await (_service as IProductService).Hide(id);
        }


        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(long id)
        {
            return await (_service as IProductService).AllowedActions(id);
        }
    }
}
