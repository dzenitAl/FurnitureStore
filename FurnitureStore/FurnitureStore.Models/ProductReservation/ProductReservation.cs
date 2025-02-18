﻿
using FurnitureStore.Models.ProductReservationItem;
using FurnitureStore.Models.User;

namespace FurnitureStore.Models.ProductReservation
{
    public class ProductReservation
    {
        public long Id { get; set; }
        public DateTime ReservationDate { get; set; }
        public string Notes { get; set; }
        public bool IsApproved { get; set; }
        public string CustomerId { get; set; }
        public List<ProductReservationItem.ProductReservationItem> ProductReservationItems { get; set; }

    }
}
