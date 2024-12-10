
namespace FurnitureStore.Models.GiftCard
{
    public class GiftCardInsertRequest
    {
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public int Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
    }
}
