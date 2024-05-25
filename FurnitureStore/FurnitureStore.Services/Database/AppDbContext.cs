using Microsoft.EntityFrameworkCore;
using FurnitureStore.Services.Configuration;

namespace FurnitureStore.Services.Database
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<Role> Roles { get; set; }
        public virtual DbSet<Product> Products { get; set; }
        public virtual DbSet<ProductReservation> ProductReservations { get; set; }
        public virtual DbSet<ProductReservationItem> ProductReservationItems { get; set; }
        public virtual DbSet<CustomFurnitureReservation> CustomFurnitureReservations { get; set; }
        public virtual DbSet<Subcategory> Subcategories { get; set; }
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<Notification> Notifications { get; set; }
        public virtual DbSet<Order> Orders { get; set; }
        public virtual DbSet<OrderItem> OrderItems { get; set; }
        public virtual DbSet<WishList> WishLists { get; set; }
        public virtual DbSet<WishListItem> WishListItems { get; set; }
        public virtual DbSet<Payment> Payments { get; set; }
        public virtual DbSet<Report> Reports { get; set; }
        public virtual DbSet<ProductPicture> ProductPictures { get; set; }
        public virtual DbSet<Promotion> Promotions { get; set; }
        public virtual DbSet<GiftCard> GiftCards { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.ApplyConfiguration(new UserConfiguration());
            builder.ApplyConfiguration(new RoleConfiguration());
            builder.ApplyConfiguration(new CustomFurnitureReservationConfiguration());
            builder.ApplyConfiguration(new SubcategoryConfiguration());
            builder.ApplyConfiguration(new ProductConfiguration());
            builder.ApplyConfiguration(new ProductReservationConfiguration());
            builder.ApplyConfiguration(new ProductReservationItemConfiguration());
            builder.ApplyConfiguration(new PromotionConfiguration());
            builder.ApplyConfiguration(new OrderConfiguration());
            builder.ApplyConfiguration(new OrderItemConfiguration());
            builder.ApplyConfiguration(new PaymentConfiguration());
            builder.ApplyConfiguration(new WishListConfiguration());
            builder.ApplyConfiguration(new WishListItemConfiguration());
            builder.ApplyConfiguration(new NotificationConfiguration());
            builder.ApplyConfiguration(new ReportConfiguration());
            builder.ApplyConfiguration(new GiftCardConfiguration());

        }
    }
}

