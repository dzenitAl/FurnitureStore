using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class WishListService : BaseCRUDService<Models.WishList.WishList, Database.WishList, WishListSearchObject,
        Models.WishList.WishListRequest, Models.WishList.WishListRequest, long>, IWishListService
    {
        public WishListService(AppDbContext context, IMapper mapper) : base(context, mapper) { }

        public async Task<Models.WishList.WishList> AddProductToWishList(long wishListId, long productId)
        {
            var wishList = await _context.WishLists.Include(w => w.Products)
                                                   .FirstOrDefaultAsync(w => w.Id == wishListId);
            if (wishList == null)
            {
                throw new Exception("Wishlist not found");
            }

            var product = await _context.Products.FindAsync(productId);
            if (product == null)
            {
                throw new Exception("Product not found");
            }

            if (!wishList.Products.Any(p => p.Id == productId))
            {
                wishList.Products.Add(product);
                await _context.SaveChangesAsync();
            }

            return _mapper.Map<Models.WishList.WishList>(wishList);
        }

        public async Task<Models.WishList.WishList> RemoveProductFromWishList(long wishListId, long productId)
        {
            var wishList = await _context.WishLists.Include(w => w.Products)
                                                   .FirstOrDefaultAsync(w => w.Id == wishListId);
            if (wishList == null)
            {
                throw new Exception("Wishlist not found");
            }

            var product = wishList.Products.FirstOrDefault(p => p.Id == productId);
            if (product != null)
            {
                wishList.Products.Remove(product);
                await _context.SaveChangesAsync();
            }

            return _mapper.Map<Models.WishList.WishList>(wishList);
        }
    }
}
