
namespace FurnitureStore.Models.Promotion

{
    public class Promotion
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public User.User Admin { get; set; }
        public List<Product.Product> Products { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public long? ImageId { get; set; }
    }
}
