using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class CustomFurnitureReservation
    {
        public int Id { get; set; }
        public DateTime ReservationDate { get; set; }
        public string ReservationStatus { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public long CategoryId { get; set; }
        public Category Category { get; set; }
    }
}
