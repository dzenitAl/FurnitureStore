
namespace FurnitureStore.Services.Interfaces
{
    internal interface ISoftDelete
    {
        DateTime? DeletedAt { get; set; }
    }
}
