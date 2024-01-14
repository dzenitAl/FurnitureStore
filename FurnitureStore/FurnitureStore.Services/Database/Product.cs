using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class Product
    {
        public long Id { get; set; }


        public string Name { get; set; }
        public string? Description { get; set; }
        public double Price { get; set; }
        public string? Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public string Delivery { get; set; }
        public long CategoryId { get; set; }
        public Category Category { get; set; }
        public long SubcategoryId { get; set; }
        public Subcategory Subcategory { get; set; }
        public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
        public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public virtual ICollection<Picture> Pictures { get; set; } = new List<Picture>();

    }
}
