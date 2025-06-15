using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace FurnitureStore.Services.Services
{
    public class PromotionService : ImageEnabledCRUDService<
        Models.Promotion.Promotion, 
        Database.Promotion, 
        PromotionSearchObject,
        Models.Promotion.PromotionRequest, 
        Models.Promotion.PromotionRequest>,
        IPromotionService
    {
        public PromotionService(
            AppDbContext context,
            IMapper mapper,
            IProductPictureService productPictureService)
            : base(context, mapper, productPictureService, "Promotion")
        {
        }

        protected override DbSet<Database.Promotion> EntityDbSet => _context.Promotions;

        protected override void SetImageId(Models.Promotion.Promotion model, long imageId)
        {
            model.ImageId = imageId;
        }

        protected override void SetImagePath(Models.Promotion.Promotion model, string path)
        {
            model.ImagePath = path;
        }

        public override async Task<Models.Promotion.Promotion> GetById(long id)
        {
            var entity = await _context.Promotions.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.Promotion.Promotion>(entity);
            return await EnrichWithImageData(result, id);
        }
        public override async Task<PagedResult<Models.Promotion.Promotion>> Get(PromotionSearchObject? search = null)
        {
            var result = await base.Get(search);

            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "Promotion" && ids.Contains(p.EntityId))
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
        public override async Task<Models.Promotion.Promotion> Insert(Models.Promotion.PromotionRequest insert)
        {
            var result = await base.Insert(insert);

            if (insert.ImageFile != null)
            {
                result = await AddImage(result.Id, insert.ImageFile);
            }

            return result;
        }

        public override async Task<Models.Promotion.Promotion> Update(long id, Models.Promotion.PromotionRequest update)
        {
            var result = await base.Update(id, update);

            if (update.ImageFile != null)
            {
                result = await UpdateImage(id, update.ImageFile);
            }

            return result;
        }

        public override IQueryable<Database.Promotion> AddInclude(IQueryable<Database.Promotion> query, PromotionSearchObject? search = null)
        {
            return base.AddInclude(query.Include(p => p.Products), search);
        }

        public override async Task BeforeInsert(Database.Promotion entity, Models.Promotion.PromotionRequest insert)
        {
            await base.BeforeInsert(entity, insert);

            if (insert.ProductIds != null && insert.ProductIds.Any())
            {
                var products = await _context.Products
                    .Where(u => insert.ProductIds.Contains(u.Id))
                    .ToListAsync();
                entity.Products = products;
            }

        }

        public override async Task BeforeUpdate(Database.Promotion entity, Models.Promotion.PromotionRequest update)
        {
            await ManageProducts(entity.Id, update);
        }

        private async Task ManageProducts(long promotionId, Models.Promotion.PromotionRequest update)
        {
            var entity = await _context.Promotions
                .Include(r => r.Products)
                .FirstOrDefaultAsync(r => r.Id == promotionId);

            if (entity != null)
            {
                var productsToRemove = entity.Products
                    .Where(i => !update.ProductIds.Contains(i.Id))
                    .ToList();

                foreach (var product in productsToRemove)
                {
                    entity.Products.Remove(product);
                }

                var currentProductIds = entity.Products.Select(p => p.Id).ToList();
                var productsToAdd = await _context.Products
                    .Where(p => update.ProductIds.Except(currentProductIds).Contains(p.Id))
                    .ToListAsync();

                foreach (var product in productsToAdd)
                {
                    entity.Products.Add(product);
                }

                await _context.SaveChangesAsync();
            }
        }
    }
}
