using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public DateTime? MinOrderDate { get; set; }
        public string Delivery { get; set; }
        public decimal? MinTotalPrice { get; set; }
        public string CustomerId { get; set; }

    }
}
