using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class WishListConfiguration : IEntityTypeConfiguration<WishList>
    {
     
        public void Configure(EntityTypeBuilder<WishList> builder)
        {
            builder.Property(w => w.Id).ValueGeneratedOnAdd();

            builder.HasOne(w => w.Customer)
                   .WithOne(u => u.WishList)
                   .HasForeignKey<WishList>(w => w.CustomerId)
                   .OnDelete(DeleteBehavior.NoAction);

            builder.HasMany(w => w.Products)
                   .WithOne()
                   .OnDelete(DeleteBehavior.Cascade);

        }
    }
}
