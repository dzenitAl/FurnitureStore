using FurnitureStore.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Interfaces
{
    public interface IOrderItemService : ICRUDService<Models.OrderItem.OrderItem, OrderItemSearchObject,
        Models.OrderItem.OrderItemRequest, Models.OrderItem.OrderItemRequest, long>
    {
    }
}
