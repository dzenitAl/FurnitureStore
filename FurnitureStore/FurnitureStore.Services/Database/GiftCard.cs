
namespace FurnitureStore.Services.Database
{
    public class GiftCard
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public decimal Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
        public long UserId { get; set; }
        public User User { get; set; }
    }
}
