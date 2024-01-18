
namespace FurnitureStore.Services.Database
{
    public class ProductPicture
    {
        public long Id { get; set; }
        public string URL { get; set; }
        public byte[] ImageData { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
