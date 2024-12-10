using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class WishListSearchObject : BaseSearchObject
    {
        public DateTime? MinDateCreated { get; set; }
        public DateTime? MaxDateCreated { get; set; }
        public string? CustomerId { get; set; }
    }

}
