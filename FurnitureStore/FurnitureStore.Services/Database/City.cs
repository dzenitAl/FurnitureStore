
namespace FurnitureStore.Services.Database
{
    public class City
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Users { get; set; }
    }
}
