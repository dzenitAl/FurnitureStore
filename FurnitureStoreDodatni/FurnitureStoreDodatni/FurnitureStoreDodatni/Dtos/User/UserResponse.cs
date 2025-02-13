namespace FurnitureStoreDodatni.Dtos.User
{
    public class UserResponse
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get { return $"{FirstName ?? ""} {LastName ?? ""}"; } }
        public bool IsUser { get; set; }
    }
}
