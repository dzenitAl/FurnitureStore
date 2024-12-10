
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class CustomFurnitureReservation : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime ReservationDate { get; set; }
        public string Note { get; set; }
        public bool ReservationStatus { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }


    }
}
