using FurnitureStore.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject
    {
        public double? MinAmount { get; set; }
        public double? MaxAmount { get; set; }
        public DateTime? MinPaymentDate { get; set; }
        public DateTime? MaxPaymentDate { get; set; }
        public string MonthName { get; set; }
        public int Year { get; set; }
        public string CustomerId { get; set; }
        public long? OrderId { get; set; }
        public long? ProductReservationId { get; set; }
    }

}
