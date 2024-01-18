
namespace FurnitureStore.Services.Database
{
    public class Subcategory
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public long CategoryId { get; set; }
        public Category Category { get; set; }
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();

    }
}
