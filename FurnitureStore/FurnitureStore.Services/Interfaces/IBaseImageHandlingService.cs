using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Services.Interfaces
{
    public interface IBaseImageHandlingService<TModel, TId>
        where TModel : class
    {
        Task<TModel> AddImage(TId id, IFormFile file);
        Task<TModel> UpdateImage(TId id, IFormFile file);
        Task<bool> DeleteImage(TId id);
    }
} 