using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class PromotionService :
        BaseCRUDService<Models.Promotion.Promotion, Database.Promotion, PromotionSearchObject,
            Models.Promotion.PromotionRequest, Models.Promotion.PromotionRequest, long>,
        IPromotionService
    {
        private readonly IProductPictureService _productPictureService;

        public PromotionService(
            AppDbContext context, 
            IMapper mapper,
            IProductPictureService productPictureService) : base(context, mapper)
        {
            _productPictureService = productPictureService;
        }

        protected async Task<Database.Promotion> FindEntity(long id)
        {
            return await _context.Promotions.FindAsync(id);
        }

        protected void SetImageId(Models.Promotion.Promotion model, long imageId)
        {
            model.ImageId = imageId;
        }

        public override async Task<Models.Promotion.Promotion> GetById(long id)
        {
            var entity = await _context.Promotions
                .Include(p => p.Products)
                .FirstOrDefaultAsync(p => p.Id == id);
            
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.Promotion.Promotion>(entity);
            var picture = await _productPictureService.GetByEntityAsync("Promotion", id);
            result.ImageId = picture?.Id;
            return result;
        }

        public override async Task<PagedResult<Models.Promotion.Promotion>> Get(PromotionSearchObject? search = null)
        {
            var result = await base.Get(search);
            
            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "Promotion" && ids.Contains(p.EntityId))
                    .ToDictionaryAsync(p => p.EntityId, p => p.Id);
                
                foreach (var item in result.Result)
                {
                    if (pictures.TryGetValue(item.Id, out var pictureId))
                        item.ImageId = pictureId;
                }
            }
            
            return result;
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

            if (insert.ImageFile != null && entity.Id != 0)
            {
                await _productPictureService.AddEntityImageAsync("Promotion", entity.Id, insert.ImageFile);
            }
        }

        public override IQueryable<Database.Promotion> AddInclude(IQueryable<Database.Promotion> query, PromotionSearchObject? search = null)
        {
            query = query.Include(p => p.Products);
            return base.AddInclude(query, search);
        }

        private async Task ManageProducts(long promotionId, Models.Promotion.PromotionRequest update)
        {
            var entity = await _context.Promotions
                .Include(r => r.Products)
                .FirstOrDefaultAsync(r => r.Id == promotionId);

            if (entity != null)
            {
                var productsToRemove = entity.Products
                    .Where(i => !update.ProductIds.Any(s => s == i.Id))
                    .ToList();

                foreach (var product in productsToRemove)
                {
                    entity.Products.Remove(product);
                }

                await _context.SaveChangesAsync();
            }
        }

        public override async Task BeforeUpdate(Database.Promotion entity, Models.Promotion.PromotionRequest update)
        {
           await this.ManageProducts(entity.Id, update);
        }

        public async Task<Models.Promotion.Promotion> UpdateImage(long id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync("Promotion", id, file);
            
            var result = _mapper.Map<Models.Promotion.Promotion>(entity);
            SetImageId(result, picture.Id);
            
            return result;
        }

        public async Task<bool> DeleteImage(long id)
        {
            return await _productPictureService.DeleteEntityImageAsync("Promotion", id);
        }
    }
}
