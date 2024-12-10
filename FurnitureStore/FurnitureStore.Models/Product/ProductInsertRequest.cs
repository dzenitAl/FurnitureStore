
using System.ComponentModel.DataAnnotations;

namespace FurnitureStore.Models.Product
{
    public class ProductInsertRequest
    {
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Barcode is required")]
        [MinLength(6)]
        [MaxLength(15)]
        public string Barcode { get; set; }

        [Required]
        [Range(0, double.MaxValue, ErrorMessage = "Price must be between 0 and the maximum value.")]
        public double Price { get; set; }
        public string Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public long SubcategoryId { get; set; }

    }

}
