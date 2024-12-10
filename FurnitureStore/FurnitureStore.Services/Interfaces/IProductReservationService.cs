
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.ProductReservation;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductReservationService : ICRUDService<ProductReservation, ProductReservationSearchObject, ProductReservationUpdateRequest,
        ProductReservationUpdateRequest, long>
    {
    }
}
