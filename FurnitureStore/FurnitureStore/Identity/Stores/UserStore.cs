using FurnitureStore.Services.Database;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Identity.Stores
{
    public class UserStore : IUserStore<User>, IUserEmailStore<User>, IUserPasswordStore<User>, IUserRoleStore<User>, IUserSecurityStampStore<User>
    {
        private readonly AppDbContext _context;
        public UserStore(AppDbContext context)
        {
            _context = context;
        }

        #region IUserStoreImplementation
        public async Task<IdentityResult> CreateAsync(User user, CancellationToken cancellationToken)
        {
            user.SecurityStamp = Guid.NewGuid().ToString();
            _context.Add(user);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return IdentityResult.Failed(new IdentityError[] { new IdentityError { Description = ex.Message } });
            }
            return IdentityResult.Success;
        }

        public async Task<IdentityResult> DeleteAsync(User user, CancellationToken cancellationToken)
        {
            _context.Users.Remove(user);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return IdentityResult.Failed(new IdentityError[] { new IdentityError { Description = ex.Message } });
            }
            return IdentityResult.Success;
        }

        public void Dispose()
        {
            //throw new NotImplementedException();
        }

        public async Task<User> FindByIdAsync(string userId, CancellationToken cancellationToken)
        {
            return await _context.Users.Include(u => u.Roles).FirstAsync(u => u.Id == userId);
        }

        public async Task<User> FindByNameAsync(string normalizedUserName, CancellationToken cancellationToken)
        {
            return await _context.Users.Include(u => u.Roles).FirstOrDefaultAsync(u => u.Username.ToUpper() == normalizedUserName.ToUpper());
        }

        public Task<string> GetNormalizedUserNameAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Username.ToUpper());
        }

        public Task<string> GetUserIdAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Id);
        }

        public Task<string> GetUserNameAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Username);
        }

        public Task SetNormalizedUserNameAsync(User user, string normalizedName, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }

        public Task SetUserNameAsync(User user, string userName, CancellationToken cancellationToken)
        {
            user.Username = userName;
            return Task.CompletedTask;
        }

        public async Task<IdentityResult> UpdateAsync(User user, CancellationToken cancellationToken)
        {
            _context.Update(user);
            try
            {
                await _context.SaveChangesAsync();
            }

            catch (Exception ex)
            {
                return IdentityResult.Failed(new IdentityError[] { new IdentityError { Description = ex.Message } });
            }
            return IdentityResult.Success;
        }
        #endregion

        #region IUserEmailStore
        public async Task<User> FindByEmailAsync(string normalizedEmail, CancellationToken cancellationToken)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email.ToUpper() == normalizedEmail.ToUpper());
        }

        public Task<string> GetEmailAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Email);
        }

        public Task<bool> GetEmailConfirmedAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult<bool>(user.EmailConfirmed);
        }

        public Task<string> GetNormalizedEmailAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Email.ToUpper());
        }
        public Task SetEmailAsync(User user, string email, CancellationToken cancellationToken)
        {

            user.Email = email;
            return Task.CompletedTask;
        }

        public Task SetEmailConfirmedAsync(User user, bool confirmed, CancellationToken cancellationToken)
        {
            user.EmailConfirmed = true;
            return Task.CompletedTask;
        }

        public Task SetNormalizedEmailAsync(User user, string normalizedEmail, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
        #endregion

        #region Password
        public Task SetPasswordHashAsync(User user, string passwordHash, CancellationToken cancellationToken)
        {
            user.PasswordHash = passwordHash;
            return Task.CompletedTask;
        }

        public Task<string> GetPasswordHashAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.PasswordHash);
        }

        public Task<bool> HasPasswordAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult(string.IsNullOrEmpty(user.PasswordHash));
        }


        #endregion

        #region Roles
        public async Task AddToRoleAsync(User user, string roleName, CancellationToken cancellationToken)
        {

            if (await this.IsInRoleAsync(user, roleName, CancellationToken.None))
            {

            }

            user.Roles.Add(GetRoleByName(roleName));
            _context.SaveChanges();
        }

        public async Task RemoveFromRoleAsync(User user, string roleName, CancellationToken cancellationToken)
        {
            if (await this.IsInRoleAsync(user, roleName, CancellationToken.None))
            {
                user.Roles.Remove(GetRoleByName(roleName));
                _context.SaveChanges();
            }
        }

        public Task<IList<string>> GetRolesAsync(User user, CancellationToken cancellationToken)
        {
            var roles = user.Roles?.Select(r => r.Name)?.ToList();
            return Task.FromResult<IList<string>>(roles);
        }

        public Task<bool> IsInRoleAsync(User user, string roleName, CancellationToken cancellationToken)
        {
            return Task.FromResult<bool>(user?.Roles.Any(r => r.Name.ToUpper() == roleName) ?? false);
        }

        public Task<IList<User>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken)
        {
            var result = _context.Roles.Include(r => r.Users).Single(r => r.Name == roleName)?.Users?.ToList();
            return Task.FromResult<IList<User>>(result);
        }

        private Role GetRoleByName(string roleName)
        {
            return _context.Roles.Single(r => r.Name.ToUpper() == roleName.ToUpper());
        }

        #endregion

        #region SecurityStamp
        public Task SetSecurityStampAsync(User user, string stamp, CancellationToken cancellationToken)
        {
            user.SecurityStamp = stamp;

            return Task.CompletedTask;
        }

        public Task<string> GetSecurityStampAsync(User user, CancellationToken cancellationToken)
        {
            return Task.FromResult<string>(user.SecurityStamp);
        }

        #endregion
    }
}
