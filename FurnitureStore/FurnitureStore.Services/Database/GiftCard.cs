
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class GiftCard : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public decimal Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
    }
}
