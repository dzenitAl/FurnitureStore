
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface IWishListItemService : ICRUDService<Models.WishListItem.WishListItem, WishListItemSearchObject,
        Models.WishListItem.WishListItemRequest, Models.WishListItem.WishListItemRequest, long>
    {
    }
}
