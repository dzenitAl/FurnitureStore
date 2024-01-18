using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class WishListItemConfiguration : IEntityTypeConfiguration<WishListItem>
    {
        public void Configure(EntityTypeBuilder<WishListItem> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(r => r.WishList).WithMany(u => u.WishListItems).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(r => r.Product).WithMany(u => u.WishListItems).OnDelete(DeleteBehavior.NoAction);

        }
    }
}
