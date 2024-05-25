
using FurnitureStore.Services.Domain.Base;

namespace FurnitureStore.Services.Database
{
    public class City : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Users { get; set; }
    }
}
