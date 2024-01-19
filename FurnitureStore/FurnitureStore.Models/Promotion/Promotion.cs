using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Promotion
{
    public class Promotion
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public User.User Admin { get; set; }
        public virtual ICollection<ProductPromotion.ProductPromotion> ProductPromotions { get; set; } = new List<ProductPromotion.ProductPromotion>();
    }
}
