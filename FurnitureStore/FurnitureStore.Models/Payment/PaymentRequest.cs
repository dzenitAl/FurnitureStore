
using FurnitureStore.Models.Enums;

namespace FurnitureStore.Models.Payment
{
    public class PaymentRequest
    {
        public string Notes { get; set; }
        public double Amount { get; set; }
        public DateTime PaymentDate { get; set; }
        public Month Month { get; set; }
        public int Year { get; set; }
        public string CustomerId { get; set; }
        public long? OrderId { get; set; }
        public long? ProductReservationId { get; set; }
    }
}
