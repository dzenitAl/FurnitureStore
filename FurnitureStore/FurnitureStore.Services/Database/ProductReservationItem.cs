
namespace FurnitureStore.Services.Database
{
    public class ProductReservationItem
    {
        public int Id { get; set; }
        public int Quantity { get; set; }
        public int ProductReservationId { get; set; }
        public ProductReservation ProductReservation { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
