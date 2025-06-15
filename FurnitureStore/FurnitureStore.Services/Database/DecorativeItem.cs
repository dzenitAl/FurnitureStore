using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class DecorativeItem : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
        public string Material { get; set; }
        public string Dimensions { get; set; }
        public string Style { get; set; }  
        public string Color { get; set; }
        public bool IsFragile { get; set; }
        public string CareInstructions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public long CategoryId { get; set; }
        public virtual Category Category { get; set; }
        public virtual ICollection<ProductPicture> Pictures { get; set; } = new List<ProductPicture>();
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }
}