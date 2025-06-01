
namespace FurnitureStore.Models.Category
{
    public class Category
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public long? ImageId { get; set; }
        public string? ImagePath { get; set; }
    }
}
