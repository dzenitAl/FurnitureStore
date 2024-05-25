using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.CustomFurnitureReservation
{
    public class CustomeFurnitureReservationUpdateRequest
    {
        public DateTime ReservationDate { get; set; }
        public string ReservationStatus { get; set; }

    }
}
