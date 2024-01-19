using FurnitureStore.Models.Picture;

namespace FurnitureStore.Models.Product
{
    public class Product
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public string Delivery { get; set; }
        public long SubcategoryId { get; set; }
        public Subcategory.Subcategory Subcategory { get; set; }
        public virtual ICollection<ProductPromotion.ProductPromotion> ProductPromotions { get; set; } = new List<ProductPromotion.ProductPromotion>();
        public virtual ICollection<ProductReservationItem.ProductReservationItem> ProductReservationItems { get; set; } = new List<ProductReservationItem.ProductReservationItem>();
        public virtual ICollection<OrderItem.OrderItem> OrderItems { get; set; } = new List<OrderItem.OrderItem>();
        public virtual ICollection<ProductPicture> ProductPictures { get; set; } = new List<ProductPicture>();
        public virtual ICollection<WishListItem.WishListItem> WishListItems { get; set; } = new List<WishListItem.WishListItem>();
    }
}
