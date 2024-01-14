using FurnitureStore.Services.Database;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Services
{
    public class TokenService
    {
        private readonly AppDbContext _dbContext;
        private readonly string _secret;
        private readonly string _issuer;
        private readonly int _durationInMinutes;

        public TokenService(AppDbContext dbContext, string secret, string issuer, int durationInMinutes)
        {
            _dbContext = dbContext;
            _secret = secret;
            _issuer = issuer;
            _durationInMinutes = durationInMinutes;
        }

        //public TokenInfo GenerateToken(User user, string ipAddress, string adminId = null, string adminUserName = null)
        //{
        //    var accessToken = GenerateAccessToken(user, adminId, adminUserName);

        //    return new TokenInfo
        //    {
        //        AccessToken = accessToken,
        //    };
        //}

        private string GenerateAccessToken(User user, string adminId = null, string adminUserName = null)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_secret);
            var tokenDescrtiptor = new SecurityTokenDescriptor();
            var claims = new ClaimsIdentity();

            foreach (var role in user.Roles)
            {
                claims.AddClaim(new Claim(ClaimTypes.Role, role.Name));
            }

            claims.AddClaim(new Claim(ClaimTypes.Name, user.Username));
            claims.AddClaim(new Claim(ClaimTypes.Email, user.Email));
            claims.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.Id));

            if (!string.IsNullOrEmpty(adminId))
                claims.AddClaim(new Claim("adminId", adminId));

            if (!string.IsNullOrEmpty(adminUserName))
                claims.AddClaim(new Claim("adminUserName", adminUserName));

            tokenDescrtiptor = new SecurityTokenDescriptor()
            {
                Subject = claims,
                IssuedAt = DateTime.UtcNow,
                Issuer = _issuer,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
                Expires = DateTime.UtcNow.AddDays(90)
            };

            var token = tokenHandler.CreateToken(tokenDescrtiptor);
            return tokenHandler.WriteToken(token);
        }
    }
}
