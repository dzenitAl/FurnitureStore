
using FurnitureStore.Models.Payment;
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class Report : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public DateTime GenerationDate { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    }
}
