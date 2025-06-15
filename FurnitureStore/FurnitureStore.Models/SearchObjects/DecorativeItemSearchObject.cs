using System;

namespace FurnitureStore.Models.SearchObjects
{
    public class DecorativeItemSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public string? Style { get; set; }
        public string? Material { get; set; }
        public string? Color { get; set; }
        public long? CategoryId { get; set; }
        public bool? IsFragile { get; set; }
    }
}