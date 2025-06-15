using FurnitureStore.Models.DecorativeItems;
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface IDecorativeItemService : ICRUDService<DecorativeItem, DecorativeItemSearchObject, 
        DecorativeItemsRequest, DecorativeItemsRequest, long>
    {
    }
}