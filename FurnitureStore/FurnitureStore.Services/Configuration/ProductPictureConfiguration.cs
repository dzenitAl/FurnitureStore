using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class ProductPictureConfiguration : IEntityTypeConfiguration<ProductPicture>
    {
        public void Configure(EntityTypeBuilder<ProductPicture> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            
            builder.Property(p => p.ProductId).IsRequired(false);
            builder.Property(p => p.DecorativeItemId).IsRequired(false);
            
            builder.HasOne(p => p.Product)
                .WithMany(c => c.ProductPictures)
                .HasForeignKey(p => p.ProductId)
                .OnDelete(DeleteBehavior.NoAction)
                .IsRequired(false);

            builder.HasOne(p => p.DecorativeItem)
                .WithMany(d => d.Pictures)
                .HasForeignKey(p => p.DecorativeItemId)
                .OnDelete(DeleteBehavior.NoAction)
                .IsRequired(false);
        }
    }
}
