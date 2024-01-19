
namespace FurnitureStore.Models.Order
{
    public class Order
    {
        public long Id { get; set; }
        public DateTime OrderDate { get; set; }
        public string Delivery { get; set; }
        public decimal TotalPrice { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public virtual ICollection<Payment.Payment> Payments { get; set; } = new List<Payment.Payment>();
        public virtual ICollection<OrderItem.OrderItem> OrderItems { get; set; } = new List<OrderItem.OrderItem>();

    }
}
