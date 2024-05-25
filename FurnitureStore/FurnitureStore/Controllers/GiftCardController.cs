using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GiftCardController : BaseCRUDController<Models.GiftCard.GiftCard,
        GiftCardSearchObject, Models.GiftCard.GiftCardInsertRequest, Models.GiftCard.GiftCardUpdateRequest, long>
    {
        public GiftCardController(ILogger<BaseController<Models.GiftCard.GiftCard, GiftCardSearchObject, long>> logger, IGiftCardService service) : base(logger, service)
        {

        }
    }
}
