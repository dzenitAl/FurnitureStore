using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WishListItemController : BaseCRUDController<Models.WishListItem.WishListItem, WishListItemSearchObject,
        Models.WishListItem.WishListItemRequest, Models.WishListItem.WishListItemRequest, long>
    {
        public WishListItemController(ILogger<BaseController<Models.WishListItem.WishListItem, WishListItemSearchObject, long>> logger, IWishListItemService service) : base(logger, service)
        {

        }
    }
}
