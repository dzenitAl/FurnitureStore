using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class WishListItemService : BaseCRUDService<Models.WishListItem.WishListItem,
        Database.WishListItem, WishListItemSearchObject, 
        Models.WishListItem.WishListItemRequest, Models.WishListItem.WishListItemRequest, long>, IWishListItemService
    {
        public WishListItemService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
