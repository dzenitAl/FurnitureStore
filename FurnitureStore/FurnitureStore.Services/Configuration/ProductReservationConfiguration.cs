using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class ProductReservationConfiguration : IEntityTypeConfiguration<ProductReservation>
    {
        public void Configure(EntityTypeBuilder<ProductReservation> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(r => r.Customer).WithMany(u => u.ProductReservations).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
