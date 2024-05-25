using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate, TId> : BaseController<T, TSearch, TId> where T : class where TSearch : class
    {
        protected new readonly ICRUDService<T, TSearch, TInsert, TUpdate, TId> _service;
        protected readonly ILogger<BaseController<T, TSearch, TId>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TSearch, TId>> logger, ICRUDService<T, TSearch, TInsert, TUpdate, TId> service)
            : base(logger, service)
        {
            _logger = logger;
            _service = service;
        }
        
        [HttpPost]
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(TId id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }
    }

}

