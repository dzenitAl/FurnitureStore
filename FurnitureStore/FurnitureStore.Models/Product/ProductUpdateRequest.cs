﻿
using System.ComponentModel.DataAnnotations;

namespace FurnitureStore.Models.Product
{
    public class ProductUpdateRequest
    {
        public string Name { get; set; }
        public string Description { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Barcode is required")]
        [MinLength(6)]
        [MaxLength(15)]
        public string Barcode { get; set; }
        public double Price { get; set; }
        public string Dimensions { get; set; }
        public bool IsAvailableInStore { get; set; }
        public bool IsAvailableOnline { get; set; }
        public long SubcategoryId { get; set; }
    }

}