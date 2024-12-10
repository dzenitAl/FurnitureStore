using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace FurnitureStore.Services.Services
{
    public class PromotionService : BaseCRUDService<Models.Promotion.Promotion, Database.Promotion, PromotionSearchObject,
        Models.Promotion.PromotionRequest, Models.Promotion.PromotionRequest,long>, IPromotionService
    {
        public PromotionService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {



        }
        public override async Task BeforeInsert(Database.Promotion entity, Models.Promotion.PromotionRequest insert)
        {
            if (insert.ProductIds != null && insert.ProductIds.Any())
            {
                var products = _context.Products.Select(u => u).Where(u => insert.ProductIds.Contains(u.Id)).ToList();
                entity.Products = products;
            }

        }
        public override IQueryable<Database.Promotion> AddInclude(IQueryable<Database.Promotion> query, PromotionSearchObject? search = null)
        {
            query = query.Include("Products");
            return base.AddInclude(query, search);
        }
        private async Task ManageProducts(long promotionId, Models.Promotion.PromotionRequest update)
        {
            try
            {
                var entity = await _context.Promotions
              .Include(r => r.Products)
              .FirstOrDefaultAsync(r => r.Id == promotionId); 
                var productsToRemove = entity.Products
         .Where(i => !update.ProductIds.Any(s => s == i.Id)).ToList();

                if (productsToRemove.Any())
                {
                    productsToRemove.ForEach(product =>
                    {
                        entity.Products.Remove(product);
                    });
                }

                var productsToAdd = update.ProductIds.Where(i => !entity.Products.Any(s => s.Id == i));

                if (productsToAdd.Any())
                {
                    var products = _context.Products.Select(u => u).Where(u => productsToAdd.Contains(u.Id)).ToList();
                    foreach (var product in products)
                    {
                        entity.Products.Add(product);
                    }
                }
            }
            catch (Exception ex)
            {
               
                throw;
            }
          

         

            

            

        }
        public override async Task BeforeUpdate(Database.Promotion entity, Models.Promotion.PromotionRequest update)
        {
           await this.ManageProducts(entity.Id, update);
        }
    }
}
