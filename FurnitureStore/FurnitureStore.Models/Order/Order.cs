
using FurnitureStore.Models.Enums;

namespace FurnitureStore.Models.Order
{
    public class Order
    {
        public long Id { get; set; }
        public DateTime OrderDate { get; set; }
        public Delivery Delivery { get; set; }
        public decimal TotalPrice { get; set; }
        public bool IsApproved { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public List<OrderItem.OrderItem> OrderItems { get; set; } = new();

    }
}
