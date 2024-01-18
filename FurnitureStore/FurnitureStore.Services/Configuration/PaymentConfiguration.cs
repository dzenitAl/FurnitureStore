using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class PaymentConfiguration : IEntityTypeConfiguration<Payment>
    {
        public void Configure(EntityTypeBuilder<Payment> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(n => n.Customer).WithMany(n => n.Payments).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.Order).WithMany(n => n.Payments).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(n => n.ProductReservation).WithMany(n => n.Payments).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
