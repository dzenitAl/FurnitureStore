using FurnitureStore.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Interfaces
{
    public interface IAccountService
    {
        public Task<UserResponse> Register(RegisterRequest request);
        //   public Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress);
    }
}
