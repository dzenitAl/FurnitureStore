
namespace FurnitureStore.Services.Database
{
    public class CustomFurnitureReservation
    {
        public long Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string Content { get; set; }
        public DateTime ReservationDate { get; set; }
        public string ReservationStatus { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }

    }
}
