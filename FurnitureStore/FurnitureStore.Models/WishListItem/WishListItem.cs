
namespace FurnitureStore.Models.WishListItem
{
    public class WishListItem
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long WishListId { get; set; }
        public WishList.WishList WishList { get; set; }
        public long ProductId { get; set; }
        public Product.Product Product { get; set; }

    }
}
