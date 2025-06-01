using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.GiftCard
{
    public class GiftCardUpdateRequest
    {
        public string Name { get; set; }
        public int Amount { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActivated { get; set; }
        public long? ImageId { get; set; }
        public IFormFile? ImageFile { get; set; }
    }

}
