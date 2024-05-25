using FurnitureStore.Models.Enums;
using FurnitureStore.Services.Domain.Base;
using System.ComponentModel.DataAnnotations.Schema;

namespace FurnitureStore.Services.Database
{
    public class User : BaseSoftDeleteEntity
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
        public City City { get; set; }
        public virtual ICollection<Role> Roles { get; set; } = new List<Role>();
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
        public virtual ICollection<Promotion> Promotions { get; set; } = new List<Promotion>();
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
        public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
        public virtual ICollection<CustomFurnitureReservation> CustomFurnitureReservations { get; set; } = new List<CustomFurnitureReservation>();
        public virtual ICollection<ProductReservation> ProductReservations { get; set; } = new List<ProductReservation>();
        public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
        public virtual ICollection<WishList> WishLists { get; set; } = new List<WishList>();
        public virtual ICollection<GiftCard> GiftCards { get; set; } = new List<GiftCard>();


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
