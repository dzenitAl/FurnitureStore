
namespace FurnitureStore.Models.Product
{
    public class Product
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public string Delivery { get; set; }
        public string? StateMachine { get; set; }

        public long SubcategoryId { get; set; }
        public Subcategory.Subcategory Subcategory { get; set; }
    }
}
