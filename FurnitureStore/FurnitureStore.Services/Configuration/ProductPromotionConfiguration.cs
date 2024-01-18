using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using FurnitureStore.Services.Database;

namespace FurnitureStore.Services.Configuration
{
    public sealed class ProductPromotionConfiguration : IEntityTypeConfiguration<ProductPromotion>
    {
        public void Configure(EntityTypeBuilder<ProductPromotion> builder)
        {
            builder.HasKey(pp => new { pp.PromotionId, pp.ProductId });
            builder.HasOne(pp => pp.Promotion).WithMany(p => p.ProductPromotions).HasForeignKey(pp => pp.PromotionId).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(pp => pp.Product).WithMany(p => p.ProductPromotions).HasForeignKey(pp => pp.ProductId).OnDelete(DeleteBehavior.NoAction);
        }
    
    }
}
