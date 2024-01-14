using FurnitureStore.Identity.Stores;
using FurnitureStore.Models.Token;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace FurnitureStore.Configuration
{
    public static class IdentityConfiguration
    {
        public static void AddIdentityInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {

            services.AddIdentity<User, Role>()
            .AddDefaultTokenProviders();

            services.Configure<IdentityOptions>(options =>
            {
                options.SignIn.RequireConfirmedEmail = false;
                options.User.RequireUniqueEmail = true;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequiredLength = 6;
            });

            services.Configure<DataProtectionTokenProviderOptions>(options =>
            {
                options.TokenLifespan = TimeSpan.FromMinutes(60);
            });

            services.AddTransient<IRoleStore<Role>, RoleStore>();
            services.AddTransient<IUserStore<User>, UserStore>();
            services.AddTransient(ts => new TokenService(ts.GetRequiredService<AppDbContext>(), configuration["JWTSettings:Key"], configuration["JWTSettings:Issuer"], int.Parse(configuration["JWTSettings:DurationInMinutes"])));
            services.AddTransient<IAccountService, AccountService>();

            services.Configure<JWTSettings>(configuration.GetSection("JWTSettings"));
            services.AddAuthentication(options =>
            {
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(o =>
            {
                o.RequireHttpsMetadata = false;
                o.SaveToken = false;
                o.TokenValidationParameters = GetTokenValidationParameters(configuration);
            });
        }

        internal static TokenValidationParameters GetTokenValidationParameters(IConfiguration configuration)
        {
            var param = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                ValidateIssuer = true,
                ValidateAudience = false,
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero,
                ValidIssuer = configuration["JWTSettings:Issuer"],
                ValidAudience = configuration["JWTSettings:Audience"],
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWTSettings:Key"]))
            };
            return param;

        }
    }
}
