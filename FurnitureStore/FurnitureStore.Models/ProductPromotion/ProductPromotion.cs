
namespace FurnitureStore.Models.ProductPromotion
{
    public class ProductPromotion
    {
        public long PromotionId { get; set; }
        public Promotion.Promotion Promotion { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }
    }
}
