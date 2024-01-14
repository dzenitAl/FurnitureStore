using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.OrderItem
{
    public class OrderItem
    {
        public int Id { get; set; }
        public int Quantity { get; set; }
        public int OrderId { get; set; }
        public Order.Order Order { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }
    }
}
