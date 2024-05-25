using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.WishList
{
    public class WishListRequest
    {
        public DateTime DateCreated { get; set; }
        public string CustomerId { get; set; }
    }

}
