
namespace FurnitureStore.Models.Subcategory
{
    public class Subcategory
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public long Categoryid { get; set; }
        public Category.Category Category { get; set; }

    }
}
