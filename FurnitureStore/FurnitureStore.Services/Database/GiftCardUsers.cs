using FurnitureStore.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class GiftCardUsers 
    {
        public long Id { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
        public long GiftCardId { get; set; }
        public GiftCard GiftCard { get; set; }
    }
}
