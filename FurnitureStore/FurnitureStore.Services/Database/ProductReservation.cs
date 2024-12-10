
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class ProductReservation : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime ReservationDate { get; set; }
        public string Notes { get; set; }
        public bool IsApproved { get; set; }
        public string CustomerId { get; set; }
        public User Customer { get; set; }
        public virtual ICollection<ProductReservationItem> ProductReservationItems { get; set; } = new List<ProductReservationItem>();

    }
}
