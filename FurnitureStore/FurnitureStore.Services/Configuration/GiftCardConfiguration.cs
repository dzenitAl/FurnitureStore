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
            builder.Property(u => u.Amount)
               .HasColumnType("decimal(18,2)");
            builder.HasOne(r => r.User).WithMany(u => u.GiftCards).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
