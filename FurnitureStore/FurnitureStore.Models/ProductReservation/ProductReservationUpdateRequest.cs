using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.ProductReservation
{
    public class ProductReservationUpdateRequest
    {
        public DateTime ReservationDate { get; set; }
        public string Notes { get; set; }
        public bool IsApproved { get; set; }
        public string CustomerId { get; set; }
        public List<long> ProductReservationItemIds { get; set; }

    }

}
