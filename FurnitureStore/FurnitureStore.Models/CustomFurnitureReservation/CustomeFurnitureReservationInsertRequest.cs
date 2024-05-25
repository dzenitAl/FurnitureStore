using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.CustomFurnitureReservation
{
    public class CustomeFurnitureReservationInsertRequest
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string Content { get; set; }
        public DateTime ReservationDate { get; set; }
    }
}
