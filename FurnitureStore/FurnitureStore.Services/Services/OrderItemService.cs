using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Services
{
    public class OrderItemService : BaseCRUDService<Models.OrderItem.OrderItem, Database.OrderItem, OrderItemSearchObject,
        Models.OrderItem.OrderItemRequest, Models.OrderItem.OrderItemRequest, long>, IOrderItemService
    {
        public OrderItemService(AppDbContext context,IMapper mapper) :base(context, mapper) { }
    }
}
