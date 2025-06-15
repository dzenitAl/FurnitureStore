using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FurnitureStore.Services.Configuration
{
    public sealed class DecorativeItemConfiguration : IEntityTypeConfiguration<DecorativeItem>
    {
        public void Configure(EntityTypeBuilder<DecorativeItem> builder)
        {
            builder.Property(d => d.Id).ValueGeneratedOnAdd();

            builder.Property(d => d.Name).IsRequired();
            builder.Property(d => d.Description).IsRequired();
            builder.Property(d => d.Price)
                .IsRequired()
                .HasColumnType("decimal(18,2)");
            builder.Property(d => d.StockQuantity).IsRequired();

            builder.HasOne(d => d.Category)
                .WithMany()
                .HasForeignKey(d => d.CategoryId)
                .IsRequired()
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasMany(d => d.Pictures)
                .WithOne(p => p.DecorativeItem)
                .HasForeignKey(p => p.DecorativeItemId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasMany(d => d.OrderItems)
                .WithOne()
                .OnDelete(DeleteBehavior.NoAction);
        }
    }
} 