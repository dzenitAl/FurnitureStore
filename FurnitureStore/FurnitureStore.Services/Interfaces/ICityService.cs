
using FurnitureStore.Models.City;
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface ICityService : ICRUDService<Models.City.City, Models.SearchObjects.BaseSearchObject, Models.City.CityRequest, Models.City.CityRequest, long>
    {
    }
}
