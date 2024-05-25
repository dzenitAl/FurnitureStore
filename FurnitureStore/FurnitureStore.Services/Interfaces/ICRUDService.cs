
namespace FurnitureStore.Services.Interfaces
{
    public interface ICRUDService<T, TSearch, TInsert, TUpdate, TId> : IService<T, TSearch, TId> where TSearch : class
    {
        Task<T> Insert(TInsert insert);
        Task<T> Update(TId id, TUpdate update);
    }
}

