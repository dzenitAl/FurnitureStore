using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.PaymentOrder
{
   
    public class PaymentOrder
    {
        public string CardNumber { get; set; }
        public string Month { get; set; }
        public string Year { get; set; }
        public string Cvc { get; set; }
        public string CardHolderName { get; set; }
        public int TotalPrice { get; set; }
    }
}
