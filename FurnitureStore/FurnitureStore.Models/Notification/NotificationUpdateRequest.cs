
namespace FurnitureStore.Models.Notification
{
    public class NotificationUpdateRequest
    {
        public string? Heading { get; set; }
        public string? Content { get; set; }
        public bool IsRead { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
}
