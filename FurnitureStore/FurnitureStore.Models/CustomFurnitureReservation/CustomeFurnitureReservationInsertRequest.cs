using FurnitureStore.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.CustomFurnitureReservation
{
    public class CustomeFurnitureReservationInsertRequest
    {
        public string Note { get; set; }
        public DateTime ReservationDate { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public string UserId { get; set; }
        //public UserResponse User { get; set; }
    }
}
