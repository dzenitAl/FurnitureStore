
using FurnitureStore.Models.Account;

namespace FurnitureStore.Models.CustomFurnitureReservation
{
    public class CustomFurnitureReservation
    {
        public long? Id { get; set; }
        public string Note { get; set; }
        public DateTime ReservationDate { get; set; }
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
        public bool ReservationStatus { get; set; }
        public string UserId { get; set; }
        //public UserResponse User { get; set; }
    }
}
