
namespace FurnitureStore.Models.SearchObjects
{
    public class CategorySearchObject :BaseSearchObject
    {
        public string? Name { get; set; }
        public string? FTS { get; set; } //FTS - Full Text Search
    }
}
