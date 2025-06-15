using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FurnitureStore.Models.Notification;
using FurnitureStore.Models.SearchObjects;


namespace FurnitureStore.Services.Interfaces
{
    public interface INotificationService : ICRUDService<Models.Notification.Notification, NotificationSearchObject, NotificationInsertRequest, NotificationUpdateRequest, long>
    {
        Task<Notification> MarkAsRead(long id);
    }
}
