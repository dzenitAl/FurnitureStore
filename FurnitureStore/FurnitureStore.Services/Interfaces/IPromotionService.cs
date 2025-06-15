
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Models.Promotion;

namespace FurnitureStore.Services.Interfaces
{
    public interface IPromotionService : 
        ICRUDService<Promotion, PromotionSearchObject, PromotionRequest, PromotionRequest, long>,
        IBaseImageHandlingService<Promotion, long>
    {
    }
}
