using AutoMapper;
using FurnitureStore.Models.Payment;
using FurnitureStore.Models.PaymentOrder;
using FurnitureStore.Models.Order;
using FurnitureStore.Models.ProductReservation;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;


namespace FurnitureStore.Services.Services
{
    public class PaymentOrderService : BaseCRUDService<Models.Payment.Payment, Database.Payment,
    OrderSearchObject, PaymentRequest, PaymentRequest, long>, IPaymentOrderService
    {
        private readonly AppDbContext _context;

        public PaymentOrderService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public async Task<Models.Order.Order?> GetOrderById(long orderId)
        {
            var orderEntity = await _context.Orders.FindAsync(orderId);
            return _mapper.Map<Models.Order.Order?>(orderEntity);
        }

        public async Task<Models.Order.Order> Create(Models.Order.Order order)
        {
            var orderEntity = _mapper.Map<Database.Order>(order); 
            _context.Orders.Add(orderEntity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Models.Order.Order>(orderEntity);
        }


        public async Task<bool> Pay(PaymentOrder model)
        {

            try
            {
                StripeConfiguration.ApiKey = "sk_test_51PXjj82Lmi8PKb51pFaHhOwalY8Z96iPU1L4q31ZJoyaa0XVuxgnX4W2mI9NOqTvLFvEv3tZJbPeLDLIiV3uBIzv00rh9GXmfs";
                var optionsToken = new TokenCreateOptions
                {
                    Card = new TokenCardOptions
                    {
                        Number = model.CardNumber,
                        ExpMonth = model.Month,
                        ExpYear = model.Year,
                        Cvc = model.Cvc,
                        Name = model.CardHolderName
                    }
                };
                ////var serviceToken = new Stripe.TokenService();
                ////Token stripeToken = await serviceToken.CreateAsync(optionsToken);
                var options = new ChargeCreateOptions
                {
                    Amount = (model.TotalPrice * 100),
                    Currency = "bam",
                    Description = "Furniture store",
                    Source = "tok_mastercard"
                };
                var service = new ChargeService();
                Charge charge = await service.CreateAsync(options);
                if (charge.Paid)
                {

                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public async Task SavePayment(PaymentRequest paymentRequest)
        {
            var payment = new Database.Payment
            {
                Amount = paymentRequest.Amount,
                Notes = paymentRequest.Notes,
                PaymentDate = DateTime.Now,
                CustomerId = paymentRequest.CustomerId,
                OrderId = paymentRequest.OrderId
            };

            _context.Payments.Add(payment); 
            await _context.SaveChangesAsync();
        }

     
    }
}
