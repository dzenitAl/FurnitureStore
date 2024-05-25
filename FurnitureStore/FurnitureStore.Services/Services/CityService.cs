using AutoMapper;
using FurnitureStore.Models.City;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class CityService : BaseCRUDService<Models.City.City, Database.City, BaseSearchObject, Models.City.City, Models.City.City, long>, ICityService
    {
        public CityService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
