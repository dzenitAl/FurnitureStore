using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Controllers
{
    public abstract class BaseImageHandlingController<TModel, TSearchObject, TInsert, TUpdate, TId> : 
        BaseCRUDController<TModel, TSearchObject, TInsert, TUpdate, TId>
        where TModel : class
        where TSearchObject : class
    {
        protected readonly IBaseImageHandlingService<TModel, TId> _imageHandlingService;
        protected readonly ILogger<BaseImageHandlingController<TModel, TSearchObject, TInsert, TUpdate, TId>> _imageLogger;

        protected BaseImageHandlingController(
    ILogger<BaseImageHandlingController<TModel, TSearchObject, TInsert, TUpdate, TId>> imageLogger,
    ICRUDService<TModel, TSearchObject, TInsert, TUpdate, TId> crudService,
    IBaseImageHandlingService<TModel, TId> imageService)
    : base(imageLogger, crudService)
        {
            _imageHandlingService = imageService;
            _imageLogger = imageLogger;
        }

        [HttpPost("addImage/{id}")]
        public virtual async Task<IActionResult> AddImage([FromRoute] TId id, [FromForm] IFormFile file)
        {
            try
            {
                var result = await _imageHandlingService.AddImage(id, file);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _imageLogger.LogError(ex, "Error adding image for entity {Id}", id);
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("updateImage/{id}")]
        public virtual async Task<IActionResult> UpdateImage([FromRoute] TId id, [FromForm] IFormFile file)
        {
            try
            {
                var result = await _imageHandlingService.UpdateImage(id, file);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _imageLogger.LogError(ex, "Error updating image for entity {Id}", id);
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("deleteImage/{id}")]
        public virtual async Task<IActionResult> DeleteImage([FromRoute] TId id)
        {
            try
            {
                var result = await _imageHandlingService.DeleteImage(id);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _imageLogger.LogError(ex, "Error deleting image for entity {Id}", id);
                return BadRequest(ex.Message);
            }
        }
    }
}
