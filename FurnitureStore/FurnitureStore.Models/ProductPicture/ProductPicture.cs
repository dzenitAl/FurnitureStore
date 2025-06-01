
namespace FurnitureStore.Models.ProductPicture
{
    public class ProductPicture
    {
        public long Id { get; set; }
        public string ImagePath { get; set; }
        public long ProductId { get; set; }
        public string EntityType { get; set; }
        public long EntityId { get; set; }


        public Product.Product Product { get; set; }

    }
}
