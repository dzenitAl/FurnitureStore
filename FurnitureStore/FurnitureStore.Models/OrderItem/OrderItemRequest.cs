using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.OrderItem
{
    public class OrderItemRequest
    {
        public int Quantity { get; set; }
        public long OrderId { get; set; }
        public long ProductId { get; set; }
    }

}
