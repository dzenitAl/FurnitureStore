
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class Category : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public virtual ICollection<Subcategory> Subcategories { get; set; } = new List<Subcategory>();

    }
}
