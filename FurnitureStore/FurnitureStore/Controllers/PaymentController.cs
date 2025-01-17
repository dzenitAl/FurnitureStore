using FurnitureStore.Models.Enums;
using FurnitureStore.Models.Order;
using FurnitureStore.Models.Payment;
using FurnitureStore.Models.PaymentOrder;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.Services;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : BaseCRUDController<Models.Payment.Payment, PaymentSearchObject, Models.Payment.PaymentRequest,
        Models.Payment.PaymentRequest, long>
    {
        private readonly IPaymentOrderService _paymentOrderService;

        public PaymentController(ILogger<BaseController<Models.Payment.Payment, PaymentSearchObject, long>> logger, IPaymentOrderService paymentOrderService,
            IPaymentService service) : base(logger, service)
        {
            _paymentOrderService = paymentOrderService;
        }
        [HttpPost("pay")]
        public virtual async Task<bool> Pay([FromBody] PaymentOrder request)
        {
            var result = await _paymentOrderService.Pay(request);
            return result;
        }
     
        [HttpPost("save")]
        public virtual async Task SavePayment([FromBody] PaymentRequest paymentRequest)
        { 
            // Create a new order if OrderId is not provided
            if (paymentRequest.OrderId == 0)
            {
                var newOrder = new Order
                {
                    OrderDate = DateTime.Now,
                    Delivery = Delivery.InStorePickup,
                    TotalPrice = (decimal)paymentRequest.Amount,
                    IsApproved = false,
                    CustomerId = paymentRequest.CustomerId
                };

                var createdOrder = await _paymentOrderService.Create(newOrder);
                paymentRequest.OrderId = createdOrder.Id; 
            }

            var order = await _paymentOrderService.GetOrderById((long)paymentRequest.OrderId);
            if (order == null)
            {
                throw new KeyNotFoundException("Order not found.");
            }

            await _paymentOrderService.SavePayment(paymentRequest);
        }

        [HttpPost("createOrder")]
        public async Task<ActionResult<Order>> CreateOrder([FromBody] Order newOrder)
        {
            if (newOrder == null)
            {
                
                return BadRequest("Order data is required.");
            }

            var createdOrder = await _paymentOrderService.Create(newOrder);
            return Ok(createdOrder);
        }

        [HttpGet("getOrder/{orderId}")]
        public async Task<ActionResult<Order>> GetOrderById(long orderId)
        {
            var order = await _paymentOrderService.GetOrderById(orderId);
            if (order == null)
            {
                return NotFound("Order not found.");
            }

            return Ok(order);
        }
    }
}
