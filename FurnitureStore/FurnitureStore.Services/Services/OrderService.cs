using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;


namespace FurnitureStore.Services.Services
{
    public class OrderService : BaseCRUDService<Models.Order.Order, Database.Order,
        OrderSearchObject, Models.Order.OrderInsertRequest, Models.Order.OrderUpdateRequest, long>, IOrderService
    {
        public OrderService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public async Task<Models.Order.Order> GetOrderWithItemsAsync(long orderId)
        {
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.Product)
                .FirstOrDefaultAsync(o => o.Id == orderId);

            if (order == null)
            {
                throw new KeyNotFoundException($"Order with ID {orderId} not found.");
            }

            return _mapper.Map<Models.Order.Order>(order);
        }


    }
}
