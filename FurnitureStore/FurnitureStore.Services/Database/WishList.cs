
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class WishList : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public string CustomerId { get; set; }
        public virtual User Customer { get; set; }
        public ICollection<Product> Products { get; set; } = new HashSet<Product>();
    }
}
