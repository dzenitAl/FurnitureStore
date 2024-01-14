using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Product
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
        public Category.Category Category { get; set; }
        public long SubcategoryId { get; set; }
        public Subcategory.Subcategory Subcategory { get; set; }
        public virtual ICollection<Reservation.Reservation> Reservations { get; set; } = new List<Reservation.Reservation>();
        public virtual ICollection<OrderItem.OrderItem> OrderItems { get; set; } = new List<OrderItem.OrderItem>();
        public virtual ICollection<Picture.Picture> Pictures { get; set; } = new List<Picture.Picture>();

    }
}
