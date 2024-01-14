using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Notification
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public long CategoryId { get; set; }
        public Category.Category Category { get; set; }
        public string AdminId { get; set; }
        public User.User Admin { get; set; }
    }
}
