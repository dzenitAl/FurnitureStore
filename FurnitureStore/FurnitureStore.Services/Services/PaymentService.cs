using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
     public class PaymentService : BaseCRUDService<Models.Payment.Payment, Database.Payment, PaymentSearchObject,
         Models.Payment.PaymentRequest, Models.Payment.PaymentRequest, long>, IPaymentService
    {
        public PaymentService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
