using FurnitureStore.Models.Account;
using FurnitureStore.Models.Enums;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AccountController : ControllerBase
    {
        private readonly IAccountService _accountService;
        private readonly ILogger<AccountController> _logger;

        public AccountController(IAccountService accountService, IServiceProvider provider)
        {
            _accountService = accountService;
        }


        [HttpPost("register")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> Register(RegisterRequest request)
        {
            try
            {

                var userResponse = await _accountService.Register(new RegisterRequest
                {
                    UserName = request.UserName,
                    Password = request.Password,
                    Email = request.Email,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Gender = request.Gender,
                    PhoneNumber = request.PhoneNumber,
                    BirthDate = request.BirthDate,
                    UserType = request.UserType,
                    CityId = request.CityId
                });

                if (userResponse == null)
                {
                    return BadRequest("Registracija nije uspela. Molimo proverite podatke.");
                }

                return Ok(userResponse);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške na serveru. Molimo pokušajte ponovo kasnije.");
            }
        }


        [AllowAnonymous]
        [HttpPost("authenticate")]
        [Consumes("application/json")]
        public async Task<ActionResult<AuthenticationResponse>> Authenticate([FromBody] AuthenticationRequest request)
        {
            return Ok(await _accountService.Authenticate(request.Username, request.Password, string.Empty));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPut("{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> Update([FromRoute] string userId, [FromBody] RegisterRequest request)
        {
            return Ok(await _accountService.Update(userId, request));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet]
        [Consumes("application/json")]
        public async Task<ActionResult<PagedResult<UserResponse>>> GetAll([FromQuery] UserSearchObject filter)
        {
            return Ok(await _accountService.GetAll(filter));
        }

        [HttpGet("{userId}")]
        public async Task<ActionResult<UserResponse>> GetUserById(string userId)
        {
            var user = await _accountService.GetUserById(userId);
            return Ok(user);
        }

    }
}
