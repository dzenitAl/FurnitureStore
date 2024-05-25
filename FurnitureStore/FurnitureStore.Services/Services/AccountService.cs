using FurnitureStore.Models.Account;
using FurnitureStore.Models.Enums;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Shared;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Encodings.Web;

namespace FurnitureStore.Services.Services
{
    public class AccountService : IAccountService
    {
        private const string AuthenticatorUriFormat = "otpauth://totp/{0}:{1}?secret={2}&issuer={0}&digits=6";
        private readonly UserManager<User> _userManager;
        private readonly AppDbContext _appDbContext;
        private SignInManager<User> _signInManager;
        private TokenService _tokenService;
        private readonly UrlEncoder _urlEncoder;

        public AccountService(UserManager<User> userManager, AppDbContext appDbContext, SignInManager<User> signInManager, UrlEncoder urlEncoder, TokenService tokenService)
        {
            _userManager = userManager;
            _appDbContext = appDbContext;
            _signInManager = signInManager;
            _tokenService = tokenService;
            _urlEncoder = urlEncoder;
        }

        

        public async Task<UserResponse> Register(RegisterRequest request)
        {
            try
            {
                string password = null;
                bool passwordGenerated = false;
                // Validate the password rule since it is not required depends on who is creating account. But if it is getting set the min lenght is 6
                if (String.IsNullOrEmpty(request.Password))
                {
                    password = "Test1234!";
                    passwordGenerated = true;
                }
                else if (request.Password.Length < 6)
                    throw new ApiException("Password can't be shorter than 6 characters!", System.Net.HttpStatusCode.BadRequest);
                else
                    password = request.Password;

                var role = request.UserType;

                if (role != null)
                {
                    request.Roles = new List<string>();
                    request.Roles.Add(role.ToString());
                }

                var user = new User()
                {
                    Email = request.Email,
                    Username = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Gender = request.Gender,
                    PhoneNumber = request.PhoneNumber,
                    BirthDate = request.BirthDate,
                    CityId= request.CityId
                };

                var result = await _userManager.CreateAsync(user, password);

                if (result.Succeeded)
                {
                    if (request.Roles?.Count > 0)
                        foreach (var userRole in request.Roles)
                            await _userManager.AddToRoleAsync(user, userRole);

                    _appDbContext.SaveChanges();
                }
                else
                    throw new ApiException(result.Errors?.First()?.Description, System.Net.HttpStatusCode.BadRequest);

                var userResult = _appDbContext.Users.FirstOrDefault(u => u.Username == user.Username);
                var token = _tokenService.GenerateToken(user, null);
                return new UserResponse() { };
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress)
        {
            var user = await _userManager.FindByNameAsync(username);

            if (user == null)
                throw new ApiException("Login incorrect", System.Net.HttpStatusCode.BadRequest);

            var result = await _signInManager.CheckPasswordSignInAsync(user, password, false);

            if (result.Succeeded)
            {
                var tokenInfo = _tokenService.GenerateToken(user, ipAddress);
                return new AuthenticationResponse
                {
                    UserName = user.Username,
                    Id = user.Id,
                    AccessToken = tokenInfo.AccessToken,
                    RefreshToken = tokenInfo.RefreshToken,
                    ExpiresAt = tokenInfo.ExpiresAt
                };
            }
            else
                throw new ApiException("Login incorrect", System.Net.HttpStatusCode.BadRequest);
        }

        public async Task<UserResponse> Update(string userId, RegisterRequest request)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                throw new ApiException("User not found", System.Net.HttpStatusCode.NotFound);

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.Gender = request.Gender;
            user.BirthDate = request.BirthDate;
            user.PhoneNumber = request.PhoneNumber;

            var role = request.UserType;

            if (role != null)
            {
                request.Roles = new List<string>();
                request.Roles.Add(role.ToString());
            }

            if (user.Roles.Any())
                user.Roles.Remove(user.Roles.FirstOrDefault());

            if (request.Roles?.Count > 0)
                foreach (var userRole in request.Roles)
                    await _userManager.AddToRoleAsync(user, userRole);

            await _appDbContext.SaveChangesAsync();
            return new UserResponse() { };
        }

        public async Task<PagedResult<UserResponse>> GetAll(UserSearchObject filter)
        {
            var users = await _appDbContext.Users
                .Include(u => u.Roles).ToListAsync();

            if (!string.IsNullOrWhiteSpace(filter?.FullName))
                users = users.Where(u => u.FirstName.Contains(filter.FullName) || u.LastName.Contains(filter.FullName)).ToList();

            if (filter?.UserTypes != null && filter.UserTypes != UserTypes.All)
                users = users.Where(u => u.Roles.Any(r => r.Name == filter?.UserTypes.Value.ToString())).ToList();

            var result = users.Select(u => new UserResponse()
            {
                FirstName = u.FirstName,
                LastName = u.LastName,
                BirthDate = u.BirthDate,
                PhoneNumber = u.PhoneNumber,
                Email = u.Email,
                Gender = u.Gender,
                UserType = this.GetUserTypes(u),
                Id = u.Id,
                Role = u.Roles.FirstOrDefault()?.Name
            }).ToList();

            return new PagedResult<UserResponse>()
            {
                Result = result,
                Count = users.Count()
            };
        }

        private UserTypes GetUserTypes(User user)
        {
            var role = user.Roles.FirstOrDefault();

            if (role.Name == "Admin")
            {
                return UserTypes.Admin;
            }
            else if (role.Name == "Customer")
            {
                return UserTypes.Customer;
            }

            return UserTypes.Admin;
        }
    }
}
