using FurnitureStore.Models.Account;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;

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
                //else if (request.Password.Length < 6)
                //    throw new ApiException("Password can't be shorter than 6 characters!", System.Net.HttpStatusCode.BadRequest);
                else
                    password = request.Password;

                //var role = request.UserType;

                //if (role != null)
                //{
                //    request.Roles = new List<string>();
                //    request.Roles.Add(role.ToString());
                //}

                var user = new User()
                {
                    Email = request.Email,
                    Username = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    // Gender = request.Gender,
                    PhoneNumber = request.PhoneNumber,
                    BirthDate = request.BirthDate
                };

                var result = await _userManager.CreateAsync(user, password);

                if (result.Succeeded)
                {
                    if (request.Roles?.Count > 0)
                        foreach (var userRole in request.Roles)
                            await _userManager.AddToRoleAsync(user, userRole);

                    _appDbContext.SaveChanges();
                }
                //else
                //    throw new ApiException(result.Errors?.First()?.Description, System.Net.HttpStatusCode.BadRequest);

                var userResult = _appDbContext.Users.FirstOrDefault(u => u.Username == user.Username);
                // var token = _tokenService.GenerateToken(user, null);
                return new UserResponse() { };
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //public async Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress)
        //{
        //    var user = await _userManager.FindByNameAsync(username);

        //    //if (user == null)
        //    //    throw new ApiException("Login incorrect", System.Net.HttpStatusCode.Unauthorized);

        //    //if (!user.EmailConfirmed)
        //    //    throw new ApiException("Email is not confirmed", System.Net.HttpStatusCode.BadRequest);

        //    var result = await _signInManager.CheckPasswordSignInAsync(user, password, false);

        //    if (result.Succeeded)
        //    {
        //       // var tokenInfo = _tokenService.GenerateToken(user, ipAddress);
        //        //return new AuthenticationResponse
        //        //{
        //        //    UserName = user.Username,
        //        //    Id = user.Id,
        //        //    AccessToken = tokenInfo.AccessToken,
        //        //    RefreshToken = tokenInfo.RefreshToken,
        //        //    ExpiresAt = tokenInfo.ExpiresAt
        //        //};
        //    }
        //    else
        //        // throw new ApiException("Login incorrect", System.Net.HttpStatusCode.Unauthorized);
        //        throw new Exception();
        //}
    }
}
