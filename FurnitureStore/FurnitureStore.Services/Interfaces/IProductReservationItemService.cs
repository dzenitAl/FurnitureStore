
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface IProductReservationItemService : ICRUDService<Models.ProductReservationItem.ProductReservationItem, ProductReservationItemSearchObject,
        Models.ProductReservationItem.ProductReservationItemRequest, Models.ProductReservationItem.ProductReservationItemRequest, long>
    {
    }
}
