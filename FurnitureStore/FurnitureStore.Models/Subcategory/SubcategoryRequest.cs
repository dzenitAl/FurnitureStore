using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Subcategory
{
    public class SubcategoryRequest
    {
        public string Name { get; set; }
        public long CategoryId { get; set; }
        public long? ImageId { get; set; }
        public IFormFile? ImageFile { get; set; }
    }
}
