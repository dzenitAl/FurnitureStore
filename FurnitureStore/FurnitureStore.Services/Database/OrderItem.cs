
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class OrderItem : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long OrderId { get; set; }
        public Order Order { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
