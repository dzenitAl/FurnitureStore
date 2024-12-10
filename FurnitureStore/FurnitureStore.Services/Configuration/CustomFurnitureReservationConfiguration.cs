using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Configuration
{
    public sealed class CustomFurnitureReservationConfiguration : IEntityTypeConfiguration<CustomFurnitureReservation>
    {
        public void Configure(EntityTypeBuilder<CustomFurnitureReservation> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(r => r.User).WithMany(u => u.CustomFurnitureReservations).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
