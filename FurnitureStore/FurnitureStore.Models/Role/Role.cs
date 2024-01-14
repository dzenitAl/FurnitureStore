using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Role
{
    public class Role
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<User.User> Users { get; set; }
    }
}
