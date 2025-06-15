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
        private readonly IOrderItemService _orderItemService;

        public OrderItemController(ILogger<BaseController<Models.OrderItem.OrderItem, OrderItemSearchObject, long>> logger, IOrderItemService service) : base(logger, service)
        {
            _orderItemService = service;
        }

        [HttpGet("GetByOrderId/{orderId}")]
        public async Task<IActionResult> GetByOrderId(long orderId)
        {
            var searchObject = new OrderItemSearchObject { OrderId = orderId };
            var result = await _orderItemService.Get(searchObject);
            return Ok(result.Result);
        }
    }
}
