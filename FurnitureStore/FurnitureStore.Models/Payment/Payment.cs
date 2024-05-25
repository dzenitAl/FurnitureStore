
using FurnitureStore.Models.Enums;
using System;

namespace FurnitureStore.Models.Payment
{
    public class Payment
    {
        public long Id { get; set; }
        public double Amount { get; set; }
        public string Notes { get; set; }
        public DateTime PaymentDate { get; set; }
        public Month Month { get; set; }
        public string MonthName { get; set; }
        public int Year { get; set; }
        public string CustomerId { get; set; }
        public User.User Customer { get; set; }
        public long? OrderId { get; set; }
        public Order.Order Order { get; set; }
        public long? ProductReservationId { get; set; }
        public ProductReservation.ProductReservation ProductReservation { get; set; }
        public long? ReportId { get; set; }
        public Report.Report Report { get; set; }
    }
}
