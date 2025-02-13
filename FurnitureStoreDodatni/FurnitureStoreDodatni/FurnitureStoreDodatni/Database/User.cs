using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Reflection;

namespace FurnitureStoreDodatni.Database
{
    public class User 
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public string PhoneNumber { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public bool EmailConfirmed { get; set; }
      
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
      

        [NotMapped]
        public string FullName
        {
            get
            {
                return FirstName + " " + LastName;
            }
        }
    }
}
