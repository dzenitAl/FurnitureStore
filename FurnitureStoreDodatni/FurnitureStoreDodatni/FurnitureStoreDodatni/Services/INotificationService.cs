using FurnitureStoreDodatni.Dtos.Notification;

namespace FurnitureStoreDodatni.Services
{
    public interface INotificationService
    {
        public Task<List<Notification>> Get(NotificationSearchObject notificationSearch);
    }
}
