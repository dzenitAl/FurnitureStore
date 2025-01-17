using FurnitureStore.Models.Order;
using FurnitureStore.Models.Payment;
using FurnitureStore.Models.PaymentOrder;
using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Interfaces
{
    public interface IPaymentOrderService : ICRUDService<Models.Payment.Payment,
OrderSearchObject, PaymentRequest, PaymentRequest, long>
    {
        Task<Order?> GetOrderById(long orderId);
        Task<Order> Create(Order order);
        Task<bool> Pay(PaymentOrder vm);
        Task SavePayment(PaymentRequest vm);
    }

}
