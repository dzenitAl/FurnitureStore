using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class GiftCardService : BaseCRUDService<Models.GiftCard.GiftCard, Database.GiftCard, 
        GiftCardSearchObject, Models.GiftCard.GiftCardInsertRequest, Models.GiftCard.GiftCardUpdateRequest, long>, IGiftCardService
    {
        private readonly IProductPictureService _productPictureService;

        public GiftCardService(
            AppDbContext context, 
            IMapper mapper,
            IProductPictureService productPictureService) : base(context, mapper)
        {
            _productPictureService = productPictureService;
        }

        protected async Task<Database.GiftCard> FindEntity(long id)
        {
            return await _context.GiftCards.FindAsync(id);
        }

        protected void SetImageId(Models.GiftCard.GiftCard model, long imageId)
        {
            model.ImageId = imageId;
        }

        public async Task<Models.GiftCard.GiftCard> UpdateImage(long id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync("GiftCard", id, file);
            
            var result = _mapper.Map<Models.GiftCard.GiftCard>(entity);
            SetImageId(result, picture.Id);
            
            return result;
        }

        public async Task<bool> DeleteImage(long id)
        {
            return await _productPictureService.DeleteEntityImageAsync("GiftCard", id);
        }

        public override async Task<Models.GiftCard.GiftCard> GetById(long id)
        {
            var entity = await _context.GiftCards.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.GiftCard.GiftCard>(entity);
            var picture = await _productPictureService.GetByEntityAsync("GiftCard", id);
            result.ImageId = picture?.Id;
            return result;
        }

        public override async Task<PagedResult<Models.GiftCard.GiftCard>> Get(GiftCardSearchObject? search = null)
        {
            var result = await base.Get(search);
            
            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "GiftCard" && ids.Contains(p.EntityId))
                    .ToDictionaryAsync(p => p.EntityId, p => p.Id);
                
                foreach (var item in result.Result)
                {
                    if (pictures.TryGetValue(item.Id, out var pictureId))
                        item.ImageId = pictureId;
                }
            }
            
            return result;
        }

        public override async Task<Models.GiftCard.GiftCard> Insert(Models.GiftCard.GiftCardInsertRequest insert)
        {
            var result = await base.Insert(insert);
            
            if (insert.ImageFile != null)
            {
                await _productPictureService.AddEntityImageAsync("GiftCard", result.Id, insert.ImageFile);
                result = await GetById(result.Id);
            }
            
            return result;
        }

        public override async Task<Models.GiftCard.GiftCard> Update(long id, Models.GiftCard.GiftCardUpdateRequest update)
        {
            var result = await base.Update(id, update);
            
            if (update.ImageFile != null)
            {
                await _productPictureService.AddEntityImageAsync("GiftCard", id, update.ImageFile);
                result = await GetById(id);
            }
            
            return result;
        }
    }
}
