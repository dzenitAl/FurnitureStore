using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class PromotionSearchObject : BaseSearchObject
    {
        public string? Heading { get; set; }
        public string? Content { get; set; }
        public string? AdminId { get; set; }
    }

}
