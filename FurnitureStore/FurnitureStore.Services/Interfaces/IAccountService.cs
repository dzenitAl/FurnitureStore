using FurnitureStore.Models.Account;
using FurnitureStore.Models.SearchObjects;
using System;

namespace FurnitureStore.Services.Interfaces
{
    public interface IAccountService
    {
        public Task<UserResponse> Register(RegisterRequest request);
        public Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress);
        public Task<UserResponse> Update(string userId, RegisterRequest request);
        public Task<PagedResult<UserResponse>> GetAll(UserSearchObject filter);
        Task<UserResponse> GetUserById(string userId);
        

    }
}
