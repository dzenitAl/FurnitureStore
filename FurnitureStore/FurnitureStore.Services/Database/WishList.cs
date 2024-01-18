
namespace FurnitureStore.Services.Database
{
    public class WishList
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public ICollection<WishListItem> WishListItems { get; set; }
    }
}
