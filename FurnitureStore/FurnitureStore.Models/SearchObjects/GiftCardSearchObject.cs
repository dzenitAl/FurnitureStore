using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class GiftCardSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public string? CardNumber { get; set; }
        public bool? IsActivated { get; set; }
    }
}
