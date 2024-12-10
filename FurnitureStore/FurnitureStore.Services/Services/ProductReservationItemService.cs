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

    }


}

