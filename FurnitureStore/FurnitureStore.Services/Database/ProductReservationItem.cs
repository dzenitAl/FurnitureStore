﻿
namespace FurnitureStore.Services.Database
{
    public class ProductReservationItem
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long ProductReservationId { get; set; }
        public ProductReservation ProductReservation { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
