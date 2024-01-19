
namespace FurnitureStore.Models.Category
{
    public class Category
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public virtual ICollection<Subcategory.Subcategory> Subcategories { get; set; } = new List<Subcategory.Subcategory>();
    }
}
