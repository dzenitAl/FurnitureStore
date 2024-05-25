using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class ProductReservationSearchObject: BaseSearchObject
    {
        public DateTime? MinReservationDate { get; set; }
        public DateTime? MaxReservationDate { get; set; }
        public string CustomerId { get; set; }
    }

}
