using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class Promotion : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
    }
}
