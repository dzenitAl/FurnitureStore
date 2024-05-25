
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Payment;

namespace FurnitureStore.Services.Interfaces
{
    public interface IPaymentService : ICRUDService<Payment, PaymentSearchObject, 
        Models.Payment.PaymentRequest, Models.Payment.PaymentRequest, long>
    {
    }
}
