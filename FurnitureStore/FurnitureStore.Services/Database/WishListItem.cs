
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class WishListItem : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public int Quantity { get; set; }
        public long WishListId { get; set; }
        public WishList WishList { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }

    }
}
