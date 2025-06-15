using FurnitureStore.Models.DecorativeItems;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DecorativeItemController : BaseCRUDController<DecorativeItem, DecorativeItemSearchObject,
        DecorativeItemsRequest, DecorativeItemsRequest, long>
    {
        public DecorativeItemController(
            ILogger<BaseController<DecorativeItem, DecorativeItemSearchObject, long>> logger,
            IDecorativeItemService service) 
            : base(logger, service)
        {
        }
    }
} 