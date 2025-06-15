
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class GiftCard : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public int Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
        public virtual ICollection<GiftCardUsers> GiftCardUsers { get; set; } = new List<GiftCardUsers>();
        public string ImagePath { get; set; }
    }
}
