using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class ProductReservationService : BaseCRUDService<Models.ProductReservation.ProductReservation, Database.ProductReservation,
        ProductReservationSearchObject, ProductReservationUpdateRequest, ProductReservationUpdateRequest , long>, IProductReservationService
    {
        public ProductReservationService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Database.ProductReservation entity, Models.ProductReservation.ProductReservationUpdateRequest insert)
        {
            if (insert.ProductReservationItemIds != null && insert.ProductReservationItemIds.Any())
            {
                var products = await _context.Products
                               .Where(u => insert.ProductReservationItemIds.Contains(u.Id))
                               .ToListAsync();


                var items = new List<ProductReservationItem>();
                foreach (var product in products)
                {
                    var productReservationItem = new ProductReservationItem
                    {

                        ProductId = product.Id,
                        Quantity = 1
                    };
                    items.Add(productReservationItem);
                }
                entity.ProductReservationItems = items;

            }

        }
        public override IQueryable<Database.ProductReservation> AddInclude(IQueryable<Database.ProductReservation> query, ProductReservationSearchObject? search = null)
        {
            query = query.Include(pr => pr.ProductReservationItems)
                         .ThenInclude(pri => pri.Product);
            return base.AddInclude(query, search);
        }
        private async Task ManageProducts(long productReservationId, ProductReservationUpdateRequest update)
        {
            var entity = await _context.ProductReservations
                .Include(pr => pr.ProductReservationItems)
                .ThenInclude(pri => pri.Product)
                .FirstOrDefaultAsync(pr => pr.Id == productReservationId);

            if (entity == null)
            {
                throw new InvalidOperationException($"ProductReservation with ID {productReservationId} not found.");
            }

            // Remove items not in the update request
            var itemsToRemove = entity.ProductReservationItems
                .Where(existingItem => !update.ProductReservationItemIds.Contains(existingItem.ProductId))
                .ToList();

            foreach (var itemToRemove in itemsToRemove)
            {
                _context.ProductReservationItems.Remove(itemToRemove);
            }

            // Add new items from the update request
            var itemsToAddIds = update.ProductReservationItemIds
                .Where(newItemId => !entity.ProductReservationItems.Any(existingItem => existingItem.ProductId == newItemId))
                .ToList();

            if (itemsToAddIds.Any())
            {
                var productsToAdd = await _context.Products
                    .Where(product => itemsToAddIds.Contains(product.Id))
                    .ToListAsync();

                foreach (var productToAdd in productsToAdd)
                {
                    var newReservationItem = new ProductReservationItem
                    {
                        ProductReservationId = entity.Id,
                        ProductId = productToAdd.Id,
                        Quantity = 1 // Default quantity
                    };

                    await _context.ProductReservationItems.AddAsync(newReservationItem);
                }
            }
        }

        public override async Task BeforeUpdate(Database.ProductReservation entity, ProductReservationUpdateRequest update)
        {
            await ManageProducts(entity.Id, update);
        }
    }
}
