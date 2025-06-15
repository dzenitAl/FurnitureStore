using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class GiftCardService : ImageEnabledCRUDService<
        Models.GiftCard.GiftCard,
        Database.GiftCard,
        GiftCardSearchObject,
        Models.GiftCard.GiftCardInsertRequest,
        Models.GiftCard.GiftCardUpdateRequest>,
        IGiftCardService
    {
        public GiftCardService(
            AppDbContext context,
            IMapper mapper,
            IProductPictureService pictureService)
            : base(context, mapper, pictureService, "GiftCard")
        {
        }

        protected override DbSet<Database.GiftCard> EntityDbSet => _context.GiftCards;

        protected override void SetImageId(Models.GiftCard.GiftCard model, long imageId)
        {
            model.ImageId = imageId;
        }

        protected override void SetImagePath(Models.GiftCard.GiftCard model, string path)
        {
            model.ImagePath = path;
        }

        public override async Task<Models.GiftCard.GiftCard> GetById(long id)
        {
            var entity = await _context.GiftCards.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.GiftCard.GiftCard>(entity);
            return await EnrichWithImageData(result, id);
        }

        public override async Task<PagedResult<Models.GiftCard.GiftCard>> Get(GiftCardSearchObject? search = null)
        {
            var result = await base.Get(search);

            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "GiftCard" && ids.Contains(p.EntityId))
                    .ToDictionaryAsync(p => p.EntityId, p => new { p.Id, p.ImagePath });

                foreach (var item in result.Result)
                {
                    if (pictures.TryGetValue(item.Id, out var pictureInfo))
                    {
                        item.ImageId = pictureInfo.Id;
                        item.ImagePath = pictureInfo.ImagePath;
                    }
                }
            }

            return result;
        }

        public override async Task<Models.GiftCard.GiftCard> Insert(Models.GiftCard.GiftCardInsertRequest insert)
        {
            var result = await base.Insert(insert);

            if (insert.ImageFile != null)
            {
                result = await AddImage(result.Id, insert.ImageFile);
            }

            return result;
        }

        public override async Task<Models.GiftCard.GiftCard> Update(long id, Models.GiftCard.GiftCardUpdateRequest update)
        {
            var result = await base.Update(id, update);

            if (update.ImageFile != null)
            {
                result = await UpdateImage(id, update.ImageFile);
            }

            return result;
        }
    }
}
