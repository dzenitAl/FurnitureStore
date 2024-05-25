using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;

namespace FurnitureStore.Controllers
{
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch, TId> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IService<T, TSearch, TId> _service;
        protected readonly ILogger<BaseController<T, TSearch, TId>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch, TId>> logger, IService<T, TSearch, TId> service)
        {
            _logger = logger;
            _service = service;
        }

        
        [HttpGet()]
        public async Task<PagedResult<T>> Get([FromQuery] TSearch? search = null)
        {
            return await _service.Get(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(TId id)
        {
            return await _service.GetById(id);
        }
    }
}