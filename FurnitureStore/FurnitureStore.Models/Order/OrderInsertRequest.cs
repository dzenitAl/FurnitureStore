using FurnitureStore.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Order
{
    public class OrderInsertRequest
    {
        public DateTime? OrderDate { get; set; }
        public Delivery? Delivery { get; set; }
        public decimal? TotalPrice { get; set; }
        public string? CustomerId { get; set; }
    }
}
