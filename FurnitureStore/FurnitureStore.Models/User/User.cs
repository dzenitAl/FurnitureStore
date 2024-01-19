using FurnitureStore.Models.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.User
{
    public class User
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public Gender Gender { get; set; }
        public string PhoneNumber { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public bool EmailConfirmed { get; set; }
        public long CityId { get; set; }
        public City.City City { get; set; }
        public virtual ICollection<Role.Role> Roles { get; set; } = new List<Role.Role>();
        public virtual ICollection<Notification.Notification> Notifications { get; set; } = new List<Notification.Notification>();
        public virtual ICollection<Payment.Payment> Payments { get; set; } = new List<Payment.Payment>();
        public virtual ICollection<Report.Report> Reports { get; set; } = new List<Report.Report>();
        public virtual ICollection<CustomFurnitureReservation.CustomFurnitureReservation> CustomFurnitureReservations { get; set; } = new List<CustomFurnitureReservation.CustomFurnitureReservation>();
        public virtual ICollection<ProductReservation.ProductReservation> Reservations { get; set; } = new List<ProductReservation.ProductReservation>();
        public virtual ICollection<Order.Order> Orders { get; set; } = new List<Order.Order>();

        public virtual ICollection<Promotion.Promotion> Promotions { get; set; } = new List<Promotion.Promotion>();
        public virtual ICollection<WishList.WishList> WishLists { get; set; } = new List<WishList.WishList>();
        public virtual ICollection<GiftCard.GiftCard> GiftCards { get; set; } = new List<GiftCard.GiftCard>();

        [NotMapped]
        public string FullName
        {
            get
            {
                return FirstName + " " + LastName;
            }
        }
    }
}
