using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : BaseCRUDController<Models.Payment.Payment, PaymentSearchObject, Models.Payment.PaymentRequest,
        Models.Payment.PaymentRequest, long>
    {
        public PaymentController(ILogger<BaseController<Models.Payment.Payment, PaymentSearchObject, long>> logger,
            IPaymentService service) : base(logger, service)
        {

        }
    }
}
