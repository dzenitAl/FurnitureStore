
using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class CustomFurnitureReservationService : BaseCRUDService<Models.CustomFurnitureReservation.CustomFurnitureReservation,
        CustomFurnitureReservation, CustomFurnitureReservationSearchObject,
        Models.CustomFurnitureReservation.CustomeFurnitureReservationInsertRequest,
        Models.CustomFurnitureReservation.CustomeFurnitureReservationUpdateRequest,long>, ICustomFurnitureReservation
    {
        public CustomFurnitureReservationService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
