using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : BaseCRUDController<Models.Notification.Notification, Models.SearchObjects.NotificationSearchObject, Models.Notification.NotificationInsertRequest, Models.Notification.NotificationUpdateRequest, long>
    {
        public NotificationController(ILogger<BaseController<Models.Notification.Notification, Models.SearchObjects.NotificationSearchObject, long>> logger, INotificationService service) : base(logger, service)
        {

        }
        [HttpPut("{id}/mark-read")]
        public async Task<IActionResult> MarkAsRead(long id)
        {
            try
            {
                var result = await ((INotificationService)_service).MarkAsRead(id);
                return Ok(result);
            }
            catch (Exception ex)
            {
                if (ex.Message == "Notification not found")
                    return NotFound();
                throw;
            }
        }

    }
}
    