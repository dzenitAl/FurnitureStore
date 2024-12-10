using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class ProductSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public string? Barcode { get; set; }

        public double? MinPrice { get; set; }
        public double? MaxPrice { get; set; }
        public bool? IsAvailableInStore { get; set; }
        public bool? IsAvailableOnline { get; set; }
        public long? SubcategoryId { get; set; }
    }

}
