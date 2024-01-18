using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class ProductReservationItemConfiguration : IEntityTypeConfiguration<ProductReservationItem>
    {
        public void Configure(EntityTypeBuilder<ProductReservationItem> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(r => r.ProductReservation).WithMany(u => u.ProductReservationItems).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(r => r.Product).WithMany(u => u.ProductReservationItems).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
