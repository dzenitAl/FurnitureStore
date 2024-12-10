
using FurnitureStore.Models.Account;

namespace FurnitureStore.Models.Notification
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public UserResponse Admin { get; set; }
    }
}
