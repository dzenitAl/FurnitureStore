using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using FurnitureStore.Services.Database;

namespace FurnitureStore.Services.Configuration
{
    public sealed class PromotionConfiguration : IEntityTypeConfiguration<Promotion>
    {
        public void Configure(EntityTypeBuilder<Promotion> builder)
        {
            builder.Property(p => p.Id).ValueGeneratedOnAdd();
            builder.HasOne(p => p.Admin).WithMany(p => p.Promotions).OnDelete(DeleteBehavior.NoAction);
            builder.HasMany(p => p.Products).WithMany(p => p.Promotions);
        }
    }
}