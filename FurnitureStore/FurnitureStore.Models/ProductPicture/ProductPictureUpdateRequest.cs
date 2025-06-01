using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.ProductPicture
{
    public class ProductPictureUpdateRequest
    {
        //public string ImagePath { get; set; }
        public long ProductId { get; set; }
        public IFormFileCollection Images { get; set; }
        public string? EntityType { get; set; }
        public long? EntityId { get; set; }
    }

}
