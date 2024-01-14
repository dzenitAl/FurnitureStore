using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class Category
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
        public virtual ICollection<CustomFurnitureReservation> CustomFurnitureReservations { get; set; } = new List<CustomFurnitureReservation>();
        public virtual ICollection<Product> Products { get; set; } = new List<Product>();
        public virtual ICollection<Subcategory> Subcategories { get; set; } = new List<Subcategory>();

    }
}
