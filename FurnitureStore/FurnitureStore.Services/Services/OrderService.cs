using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;


namespace FurnitureStore.Services.Services
{
    public class OrderService : BaseCRUDService<Models.Order.Order, Database.Order,
        OrderSearchObject, Models.Order.OrderInsertRequest, Models.Order.OrderUpdateRequest, long>, IOrderService
    {
        public OrderService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
