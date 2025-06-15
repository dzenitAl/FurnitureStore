
namespace FurnitureStore.Models.Notification
{
    public class NotificationInsertRequest
    {
        public string? Heading { get; set; }
        public string? Content { get; set; }
        public string? AdminId { get; set; }
        public bool IsRead { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
}
