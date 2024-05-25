using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PromotionController : BaseCRUDController<Models.Promotion.Promotion, PromotionSearchObject,
        Models.Promotion.PromotionRequest, Models.Promotion.PromotionRequest, long>
    {
        public PromotionController(ILogger<BaseController<Models.Promotion.Promotion, PromotionSearchObject, long>> logger, IPromotionService service) : base(logger, service)
        {
        }
    }
}
