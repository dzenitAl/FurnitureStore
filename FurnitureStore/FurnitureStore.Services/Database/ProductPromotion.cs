
namespace FurnitureStore.Services.Database
{
    public class ProductPromotion
    {
        public long PromotionId { get; set; }
        public Promotion Promotion { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
