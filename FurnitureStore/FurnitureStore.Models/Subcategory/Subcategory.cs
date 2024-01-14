using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Subcategory
{
    public class Subcategory
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public long CategoryId { get; set; }
        public Category.Category Category { get; set; }
        public virtual ICollection<Product.Product> Products { get; set; } = new List<Product.Product>();

    }
}
