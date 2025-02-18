﻿
using FurnitureStore.Services.Domain.Base;


namespace FurnitureStore.Services.Database
{
    public class Product : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Barcode { get; set; }
        public double Price { get; set; }
        public string Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public long SubcategoryId { get; set; }
        public Subcategory Subcategory { get; set; }
        public virtual ICollection<Promotion> Promotions { get; set; } = new List<Promotion>();
        public virtual ICollection<ProductReservationItem> ProductReservationItems { get; set; } = new List<ProductReservationItem>();
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<ProductPicture> ProductPictures { get; set; } = new List<ProductPicture>();

    }
}
