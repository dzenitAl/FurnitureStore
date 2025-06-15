using AutoMapper;
using FurnitureStore.Models.DecorativeItems;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class DecorativeItemService : BaseCRUDService<Models.DecorativeItems.DecorativeItem, Database.DecorativeItem, 
        DecorativeItemSearchObject, DecorativeItemsRequest, DecorativeItemsRequest, long>, 
        IDecorativeItemService
    {
        public DecorativeItemService(AppDbContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.DecorativeItem> AddFilter(IQueryable<Database.DecorativeItem> query, DecorativeItemSearchObject? search = null)
        {
            if (search == null)
                return query;

            if (!string.IsNullOrEmpty(search.Name))
                query = query.Where(x => x.Name.Contains(search.Name));

            if (search.MinPrice.HasValue)
                query = query.Where(x => x.Price >= search.MinPrice.Value);

            if (search.MaxPrice.HasValue)
                query = query.Where(x => x.Price <= search.MaxPrice.Value);

            if (!string.IsNullOrEmpty(search.Style))
                query = query.Where(x => x.Style == search.Style);

            if (!string.IsNullOrEmpty(search.Material))
                query = query.Where(x => x.Material == search.Material);

            if (!string.IsNullOrEmpty(search.Color))
                query = query.Where(x => x.Color == search.Color);

            if (search.CategoryId.HasValue)
                query = query.Where(x => x.CategoryId == search.CategoryId.Value);

            if (search.IsFragile.HasValue)
                query = query.Where(x => x.IsFragile == search.IsFragile.Value);

            return query.Include(x => x.Category)
                       .Include(x => x.Pictures);
        }
    }
}