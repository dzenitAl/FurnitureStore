
namespace FurnitureStore.Models.WishList
{
    public class WishList
    {
        public long Id { get; set; }
        public DateTime DateCreated { get; set; }
        public  string CustomerId { get; set; }
        public virtual User.User Customer { get; set; }
        public virtual ICollection<Product.Product> Products { get; set; } = new HashSet<Product.Product>();

    }
}
