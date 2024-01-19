
namespace FurnitureStore.Models.City
{
    public class City
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<User.User> Users { get; set; }
    }
}
