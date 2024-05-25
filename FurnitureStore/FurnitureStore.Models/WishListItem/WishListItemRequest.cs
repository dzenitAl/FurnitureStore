using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.WishListItem
{
    public class WishListItemRequest
    {
        public int Quantity { get; set; }
        public long WishListId { get; set; }
        public long ProductId { get; set; }
    }
}
