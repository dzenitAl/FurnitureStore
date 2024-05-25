using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Product
{
    public class ProductUpdateRequest
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public string Delivery { get; set; }
        public long SubcategoryId { get; set; }
    }

}
