
namespace FurnitureStore.Services.Database
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
  
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
