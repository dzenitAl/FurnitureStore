
namespace FurnitureStore.Models.SearchObjects
{
    public class CustomFurnitureReservationSearchObject : BaseSearchObject
    {
   
        public DateTime? MinReservationDate { get; set; }
        public DateTime? MaxReservationDate { get; set; }
        public string? ReservationStatus { get; set; }
        public string? UserId { get; set; }
    }

}
