using FurnitureStore.Models.Enums;
using System.ComponentModel.DataAnnotations;


namespace FurnitureStore.Models.Account
{
    public class RegisterRequest
    {
        [Required, MaxLength(50)]
        public string FirstName { get; set; }
        [Required, MaxLength(50)]
        public string LastName { get; set; }
        [EmailAddress]
        [Required, MaxLength(100)]
        public string Email { get; set; }
        [Required]
        public Gender Gender { get; set; }
        public DateTime? BirthDate { get; set; }
        [MaxLength(50)]
        public string PhoneNumber { get; set; }
        [Required]
        [MinLength(5), MaxLength(100)]
        public string? UserName { get; set; }
        public string? Password { get; set; }
        [Compare("Password")]
        public string? ConfirmPassword { get; set; }
        public List<string>? Roles { get; set; }
        public UserTypes UserType { get; set; }
        public long CityId { get; set; }
        
    }
}
