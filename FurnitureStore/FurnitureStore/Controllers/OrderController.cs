using FurnitureStore.Models.Order;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : BaseCRUDController<Models.Order.Order,
        OrderSearchObject, Models.Order.OrderInsertRequest, Models.Order.OrderUpdateRequest, long>
    {
        public OrderController(ILogger<BaseController<Models.Order.Order, OrderSearchObject, long>> logger, IOrderService service) : base(logger, service)
        {
        }
    }

}
