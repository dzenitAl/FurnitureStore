using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WishListController : BaseCRUDController<Models.WishList.WishList, WishListSearchObject,
        Models.WishList.WishListRequest, Models.WishList.WishListRequest, long>
    {
        public WishListController(ILogger<BaseController<Models.WishList.WishList, WishListSearchObject, long>> logger, IWishListService service) : base(logger, service)
        {

        }
    }
}

