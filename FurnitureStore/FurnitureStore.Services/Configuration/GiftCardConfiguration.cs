using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using FurnitureStore.Services.Database;

namespace FurnitureStore.Services.Configuration
{
    public sealed class GiftCardConfiguration : IEntityTypeConfiguration<GiftCard>
    {
        public void Configure(EntityTypeBuilder<GiftCard> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasMany(r => r.GiftCardUsers).WithOne(u => u.GiftCard).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
