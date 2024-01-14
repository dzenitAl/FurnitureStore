using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Database
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public long CategoryId { get; set; }
        public Category Category { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
