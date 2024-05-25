using FurnitureStore.Models.City;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : BaseCRUDController<Models.City.City, BaseSearchObject, Models.City.City, Models.City.City, long>
    {
        public CityController(ILogger<BaseController<Models.City.City, BaseSearchObject, long>> logger, ICityService service) : base(logger, service)
        {

        }
    }
}
