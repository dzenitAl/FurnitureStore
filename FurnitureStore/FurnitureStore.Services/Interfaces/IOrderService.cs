
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Order;

namespace FurnitureStore.Services.Interfaces
{
    public interface IOrderService :ICRUDService<Order, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest, long>
    {
    }
}
