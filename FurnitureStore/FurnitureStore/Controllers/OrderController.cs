using FurnitureStore.Models.Order;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : BaseCRUDController<Order, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest, long>
    {
        private readonly IOrderService _orderService;

        public OrderController(ILogger<BaseController<Order, OrderSearchObject, long>> logger, IOrderService orderService)
            : base(logger, orderService)
        {
            _orderService = orderService;
        }

        [HttpGet("{id}/details")]
        public async Task<IActionResult> GetOrderWithItems(long id)
        {
            var order = await _orderService.GetOrderWithItemsAsync(id);

            if (order == null)
            {
                return NotFound();
            }

            return Ok(order);
        }
    }
}
