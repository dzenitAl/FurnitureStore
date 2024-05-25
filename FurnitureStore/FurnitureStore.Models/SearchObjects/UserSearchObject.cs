using FurnitureStore.Models.Enums;

namespace FurnitureStore.Models.SearchObjects
{
    public class UserSearchObject
    {
        public string? FullName { get; set; }
        public UserTypes? UserTypes { get; set; }
    }
}
