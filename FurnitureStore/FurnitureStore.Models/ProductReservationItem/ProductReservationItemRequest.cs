using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.ProductReservationItem
{
    public class ProductReservationItemRequest
    {
        public int Quantity { get; set; }
        public long ProductReservationId { get; set; }
        public long ProductId { get; set; }
    }

}
