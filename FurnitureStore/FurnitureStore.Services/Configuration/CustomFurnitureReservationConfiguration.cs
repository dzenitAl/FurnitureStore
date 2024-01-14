using FurnitureStore.Services.Database;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Configuration
{
    public sealed class CustomFurnitureReservationConfiguration : IEntityTypeConfiguration<CustomFurnitureReservation>
    {
        public void Configure(EntityTypeBuilder<CustomFurnitureReservation> builder)
        {
            builder.Property(u => u.Id).ValueGeneratedOnAdd();
            builder.HasOne(r => r.Customer).WithMany(u => u.CustomFurnitureReservations).OnDelete(DeleteBehavior.NoAction);
            builder.HasOne(r => r.Category).WithMany(u => u.CustomFurnitureReservations).OnDelete(DeleteBehavior.NoAction);
        }
    }
}
