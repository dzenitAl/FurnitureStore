
namespace FurnitureStore.Models.ProductReservationItem
{
    public class ProductReservationItem
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long ProductReservationId { get; set; }
        public ProductReservation.ProductReservation ProductReservation { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }
    }
}
