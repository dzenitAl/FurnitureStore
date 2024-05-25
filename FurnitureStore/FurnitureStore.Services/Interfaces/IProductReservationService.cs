
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductReservation;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductReservationService : ICRUDService<ProductReservation, ProductReservationSearchObject, ProductReservation,
        ProductReservationUpdateRequest, long>
    {
    }
}
