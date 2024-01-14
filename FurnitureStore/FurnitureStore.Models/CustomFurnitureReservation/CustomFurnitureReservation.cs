using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.CustomFurnitureReservation
{
    public class CustomFurnitureReservation
    {
        public int Id { get; set; }
        public DateTime ReservationDate { get; set; }
        public string ReservationStatus { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public long CategoryId { get; set; }
        public Category.Category Category { get; set; }
    }
}
