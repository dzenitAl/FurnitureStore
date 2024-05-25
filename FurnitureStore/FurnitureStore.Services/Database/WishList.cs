
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class WishList : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public ICollection<WishListItem> WishListItems { get; set; }
    }
}
