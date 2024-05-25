
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface ICustomFurnitureReservation : ICRUDService<Models.CustomFurnitureReservation.CustomFurnitureReservation, Models.SearchObjects.CustomFurnitureReservationSearchObject,
        Models.CustomFurnitureReservation.CustomeFurnitureReservationInsertRequest, Models.CustomFurnitureReservation.CustomeFurnitureReservationUpdateRequest, long
        >
    {
    }
}
