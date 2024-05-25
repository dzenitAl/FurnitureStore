
namespace FurnitureStore.Models.SearchObjects
{
    public class CustomFurnitureReservationSearchObject : BaseSearchObject
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime? MinReservationDate { get; set; }
        public DateTime? MaxReservationDate { get; set; }
        public string ReservationStatus { get; set; }
        public string AdminId { get; set; }
    }

}
