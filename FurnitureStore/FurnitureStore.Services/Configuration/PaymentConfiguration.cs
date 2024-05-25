using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class PaymentConfiguration : IEntityTypeConfiguration<Payment>
    {
        public void Configure(EntityTypeBuilder<Payment> builder)
        {
            builder.Property(p => p.Id).ValueGeneratedOnAdd();
            builder.HasOne(p => p.Customer).WithMany(p => p.Payments).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(p => p.Order).WithMany(p => p.Payments).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(p => p.ProductReservation).WithMany(p => p.Payments).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(p => p.Report).WithMany(p => p.Payments).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
