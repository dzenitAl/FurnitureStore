
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class Notification : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
  
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
