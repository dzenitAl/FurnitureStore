using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.DecorativeItems
{
    public class DecorativeItemsRequest
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
        public string Material { get; set; }
        public string Dimensions { get; set; }
        public string Style { get; set; }
        public string Color { get; set; }
        public bool IsFragile { get; set; }
        public string CareInstructions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public long CategoryId { get; set; }
    }
}
