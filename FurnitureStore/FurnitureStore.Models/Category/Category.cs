using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Category
{
    public class Category
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public virtual ICollection<Notification.Notification> Notifications { get; set; } = new List<Notification.Notification>();
        public virtual ICollection<CustomFurnitureReservation.CustomFurnitureReservation> CustomFurnitureReservations { get; set; } = new List<CustomFurnitureReservation.CustomFurnitureReservation>();
        public virtual ICollection<Product.Product> Products { get; set; } = new List<Product.Product>();
        public virtual ICollection<Subcategory.Subcategory> Subcategories { get; set; } = new List<Subcategory.Subcategory>();
    }
}
