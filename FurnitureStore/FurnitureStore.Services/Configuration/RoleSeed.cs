using FurnitureStore.Models.Enums;
using FurnitureStore.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Configuration
{
    internal class RolesSeed
    {
        public static Role[] Data =
        {
            new Role{ Id="23d19d79-7a80-2ar7-33jh-836b57a1we55", Name=Roles.Admin},
            new Role{ Id= "567508ac-1c2s-t941-5er1-9efck27zz1", Name=Roles.Customer}
        };
    }
}
