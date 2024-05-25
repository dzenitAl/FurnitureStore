using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderItemController : BaseCRUDController<Models.OrderItem.OrderItem, OrderItemSearchObject,
        Models.OrderItem.OrderItemRequest, Models.OrderItem.OrderItemRequest, long>
    {
        public OrderItemController(ILogger<BaseController<Models.OrderItem.OrderItem, OrderItemSearchObject, long>> logger, IOrderItemService service) : base(logger, service)
        {
        }
    }
}
