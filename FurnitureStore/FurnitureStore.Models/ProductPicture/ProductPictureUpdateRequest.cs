using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.ProductPicture
{
    public class ProductPictureUpdateRequest
    {
        public string URL { get; set; }
        public byte[] ImageData { get; set; }
    }

}
