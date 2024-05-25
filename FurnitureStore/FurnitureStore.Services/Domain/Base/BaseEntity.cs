using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Domain.Base
{
    public abstract class BaseEntity : ITrackTimes
    {
        public string? CreatedById { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public string? LastModifiedBy { get; set; }

        public DateTime? LastModified { get; set; }
    }
}
