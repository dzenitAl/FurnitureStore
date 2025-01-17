using FurnitureStore.Models.City;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class CityController : BaseCRUDController<Models.City.City, BaseSearchObject, Models.City.CityRequest, Models.City.CityRequest, long>
    {
        public CityController(ILogger<BaseController<Models.City.City, BaseSearchObject, long>> logger, ICityService service) : base(logger, service)
        {

        }
    }
}
