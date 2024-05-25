using FurnitureStore.Models.CustomFurnitureReservation;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomFurnitureReservationController : BaseCRUDController<CustomFurnitureReservation,
         CustomFurnitureReservationSearchObject,
        CustomeFurnitureReservationInsertRequest,
        CustomeFurnitureReservationUpdateRequest, long>
    {
        public CustomFurnitureReservationController(ILogger<BaseController<CustomFurnitureReservation,
         CustomFurnitureReservationSearchObject,long>> logger, 
            ICustomFurnitureReservation service) : base(logger, service)


        {
        }
    }
}
