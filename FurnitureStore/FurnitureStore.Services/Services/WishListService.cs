using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class WishListService : BaseCRUDService<Models.WishList.WishList, Database.WishList, WishListSearchObject,
        Models.WishList.WishListRequest, Models.WishList.WishListRequest, long>, IWishListService
    {
        public WishListService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
