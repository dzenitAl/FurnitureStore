
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Promotion;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Interfaces
{
    public interface IPromotionService : ICRUDService<Promotion, PromotionSearchObject, PromotionRequest, PromotionRequest, long>
    {
        Task<Models.Promotion.Promotion> UpdateImage(long id, IFormFile file);
    Task<bool> DeleteImage(long id);
    }
}
