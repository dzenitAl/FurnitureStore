
using FurnitureStore.Models.City;
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface ICityService : ICRUDService<Models.City.City, Models.SearchObjects.BaseSearchObject, Models.City.City, Models.City.City, long>
    {
    }
}
