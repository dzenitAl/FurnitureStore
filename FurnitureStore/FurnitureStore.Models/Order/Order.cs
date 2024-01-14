using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Order
{
    public class Order
    {
        public int Id { get; set; }
        public DateTime OrderDate { get; set; }
        public double TotalPrice { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public virtual ICollection<OrderItem.OrderItem> OrderItems { get; set; } = new List<OrderItem.OrderItem>();

    }
}
