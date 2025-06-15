using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PromotionController : BaseImageHandlingController<
        Models.Promotion.Promotion,
        PromotionSearchObject,
        Models.Promotion.PromotionRequest,
        Models.Promotion.PromotionRequest,
        long>
    {
        public PromotionController(
            ILogger<BaseImageHandlingController<Models.Promotion.Promotion, PromotionSearchObject, Models.Promotion.PromotionRequest, Models.Promotion.PromotionRequest, long>> logger,
            IPromotionService service)
            : base(logger, service, service)
        {
        }
    }
}
