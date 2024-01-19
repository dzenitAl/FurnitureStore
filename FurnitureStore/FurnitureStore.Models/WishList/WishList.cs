
namespace FurnitureStore.Models.WishList
{
    public class WishList
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public ICollection<WishListItem.WishListItem> WishListItems { get; set; }
    }
}
