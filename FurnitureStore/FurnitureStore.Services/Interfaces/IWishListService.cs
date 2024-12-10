
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.WishList;

namespace FurnitureStore.Services.Interfaces
{
    public interface IWishListService : ICRUDService<WishList, WishListSearchObject, WishListRequest, WishListRequest, long>
    {
        Task<WishList> AddProductToWishList(long wishListId, long productId);
        Task<WishList> RemoveProductFromWishList(long wishListId, long productId);
    }
}
