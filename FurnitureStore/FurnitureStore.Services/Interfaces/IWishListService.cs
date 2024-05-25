
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.WishList;

namespace FurnitureStore.Services.Interfaces
{
    public interface IWishListService : ICRUDService<WishList, WishListSearchObject, WishListRequest, WishListRequest, long>
    {
    }
}
