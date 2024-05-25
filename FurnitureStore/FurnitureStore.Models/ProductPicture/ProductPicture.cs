
namespace FurnitureStore.Models.ProductPicture
{
    public class ProductPicture
    {
        public long Id { get; set; }
        public string URL { get; set; }
        public byte[] ImageData { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }
    }
}
