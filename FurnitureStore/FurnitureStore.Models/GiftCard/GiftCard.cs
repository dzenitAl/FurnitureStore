
namespace FurnitureStore.Models.GiftCard
{
    public class GiftCard
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public int Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
        public long? ImageId { get; set; }
        public string? ImagePath { get; set; }
    }
}
