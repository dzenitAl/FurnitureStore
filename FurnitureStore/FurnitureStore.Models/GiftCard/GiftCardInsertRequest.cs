
namespace FurnitureStore.Models.GiftCard
{
    public class GiftCardInsertRequest
    {
        public string Name { get; set; }
        public decimal Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
    }
}
