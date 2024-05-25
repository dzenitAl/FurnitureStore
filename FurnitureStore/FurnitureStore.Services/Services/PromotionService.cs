using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class PromotionService : BaseCRUDService<Models.Promotion.Promotion, Database.Promotion, PromotionSearchObject,
        Models.Promotion.PromotionRequest, Models.Promotion.PromotionRequest,long>, IPromotionService
    {
        public PromotionService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
