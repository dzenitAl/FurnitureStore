using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class OrderConfiguration : IEntityTypeConfiguration<Order>
    {
        public void Configure(EntityTypeBuilder<Order> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.Property(u => u.TotalPrice)
               .HasColumnType("decimal(18,2)");
            builder.HasOne(r => r.Customer).WithMany(u => u.Orders).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
