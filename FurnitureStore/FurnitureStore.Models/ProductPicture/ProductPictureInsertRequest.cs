using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.ProductPicture
{
    public class ProductPictureInsertRequest
    {
        public string ImagePath { get; set; }
        public long ProductId { get; set; }
    }
}
