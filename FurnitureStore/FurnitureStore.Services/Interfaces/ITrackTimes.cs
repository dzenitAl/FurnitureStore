
namespace FurnitureStore.Services.Interfaces
{
    internal interface ITrackTimes : ITrackCreationTime
    {
        DateTime? LastModified { get; set; }
    }
}
