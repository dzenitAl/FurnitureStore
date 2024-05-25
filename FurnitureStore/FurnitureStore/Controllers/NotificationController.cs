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
    }
}
    