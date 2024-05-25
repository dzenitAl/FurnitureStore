
namespace FurnitureStore.Models.SearchObjects
{
    public class WishListItemSearchObject : BaseSearchObject
    {
        public int? MinQuantity { get; set; }
        public int? MaxQuantity { get; set; }
        public long? WishListId { get; set; }
        public long? ProductId { get; set; }
    }

}
