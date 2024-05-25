using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class ProductReservationItemSearchObject : BaseSearchObject
    {
        public int? MinQuantity { get; set; }
        public int? MaxQuantity { get; set; }
        public long? ProductReservationId { get; set; }
        public long? ProductId { get; set; }
    }

}
