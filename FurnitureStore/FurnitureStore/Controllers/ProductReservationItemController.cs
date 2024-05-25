using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductReservationItemController : BaseCRUDController<Models.ProductReservationItem.ProductReservationItem, ProductReservationItemSearchObject,
        Models.ProductReservationItem.ProductReservationItemRequest, Models.ProductReservationItem.ProductReservationItemRequest, long>
    {
        public ProductReservationItemController(ILogger<BaseController<Models.ProductReservationItem.ProductReservationItem,
            ProductReservationItemSearchObject, long>> logger,
            IProductReservationItemService service) : base(logger, service)
        {

        }
    }
}
