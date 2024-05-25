using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class ProductReservationService : BaseCRUDService<Models.ProductReservation.ProductReservation, Database.ProductReservation,
        ProductReservationSearchObject, Models.ProductReservation.ProductReservation, ProductReservationUpdateRequest , long>, IProductReservationService
    {
        public ProductReservationService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
