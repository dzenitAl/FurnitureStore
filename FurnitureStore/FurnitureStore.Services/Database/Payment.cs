
namespace FurnitureStore.Services.Database
{
    public class Payment
    {
        public long Id { get; set; }
        public double Amount { get; set; }
        public string Notes { get; set; }
        public DateTime PaymentDate { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public long? OrderId { get; set; }
        public Order Order { get; set; }
        public long? ProductReservationId { get; set; }
        public ProductReservation ProductReservation { get; set; }
        
    }
}
