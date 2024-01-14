using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class Picture
    {
        public int Id { get; set; }
        public string URL { get; set; }
        public byte[] ImageData { get; set; }
        public long ProductId { get; set; }
        public Product Product { get; set; }
    }
}
