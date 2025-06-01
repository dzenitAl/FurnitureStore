using AutoMapper;
using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class ProductReservationItemService : BaseCRUDService<Models.ProductReservationItem.ProductReservationItem,
        Database.ProductReservationItem, ProductReservationItemSearchObject,
        Models.ProductReservationItem.ProductReservationItemRequest,
        Models.ProductReservationItem.ProductReservationItemRequest, long>, IProductReservationItemService

    {
        public ProductReservationItemService(AppDbContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.ProductReservationItem> AddFilter(IQueryable<Database.ProductReservationItem> query, ProductReservationItemSearchObject? search = null)
        {
            if (search == null)
                return query;

            if (search.ProductReservationId.HasValue)
                query = query.Where(x => x.ProductReservationId == search.ProductReservationId.Value);

            if (search.MinQuantity.HasValue)
                query = query.Where(x => x.Quantity >= search.MinQuantity.Value);

            if (search.MaxQuantity.HasValue)
                query = query.Where(x => x.Quantity <= search.MaxQuantity.Value);

            if (search.ProductId.HasValue)
                query = query.Where(x => x.ProductId == search.ProductId.Value);

            return query;
        }

    }


}

