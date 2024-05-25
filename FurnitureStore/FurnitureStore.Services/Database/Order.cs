
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class Order : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime OrderDate { get; set; }
        public string Delivery { get; set; }
        public decimal TotalPrice { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    }
}
