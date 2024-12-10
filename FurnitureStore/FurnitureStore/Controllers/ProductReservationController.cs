using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductReservationController : BaseCRUDController<Models.ProductReservation.ProductReservation,
        ProductReservationSearchObject, ProductReservationUpdateRequest, ProductReservationUpdateRequest, long>
    {
        public ProductReservationController(ILogger<BaseController<Models.ProductReservation.ProductReservation, ProductReservationSearchObject, long>> logger,
            IProductReservationService service) : base(logger, service)

        {

        }
    }
}
