using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Domain.Base
{
    public class BaseSoftDeleteEntity : BaseEntity, ISoftDelete
    {
        public DateTime? DeletedAt { get; set; }

        public bool IsDeleted => DeletedAt.HasValue;
    }
}
