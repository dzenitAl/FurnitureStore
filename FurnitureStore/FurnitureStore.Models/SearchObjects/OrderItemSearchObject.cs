
namespace FurnitureStore.Models.SearchObjects
{
    public class OrderItemSearchObject : BaseSearchObject
    {
        public int? MinQuantity { get; set; }
        public long? OrderId { get; set; }
        public long? ProductId { get; set; }
    }
}
