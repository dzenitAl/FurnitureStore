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
        private readonly IWishListService _wishListService;

        public WishListController(ILogger<BaseController<Models.WishList.WishList, WishListSearchObject, long>> logger, IWishListService service)
            : base(logger, service)
        {
            _wishListService = service;
        }

        [HttpPut("{wishListId}/AddProduct/{productId}")]
        public async Task<IActionResult> AddProductToWishList(long wishListId, long productId)
        {
            try
            {
                var updatedWishList = await _wishListService.AddProductToWishList(wishListId, productId);
                return Ok(updatedWishList); 
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message }); 
            }
        }

        [HttpDelete("{wishListId}/RemoveProduct/{productId}")]
        public async Task<IActionResult> RemoveProductFromWishList(long wishListId, long productId)
        {
            try
            {
                var updatedWishList = await _wishListService.RemoveProductFromWishList(wishListId, productId);
                return Ok(updatedWishList);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message }); 
            }
        }
    }
}
