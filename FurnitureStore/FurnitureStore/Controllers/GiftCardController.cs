using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GiftCardController : BaseImageHandlingController<
        Models.GiftCard.GiftCard,
        GiftCardSearchObject,
        Models.GiftCard.GiftCardInsertRequest,
        Models.GiftCard.GiftCardUpdateRequest,
        long>
    {
        public GiftCardController(
            ILogger<BaseImageHandlingController<Models.GiftCard.GiftCard, GiftCardSearchObject, Models.GiftCard.GiftCardInsertRequest, Models.GiftCard.GiftCardUpdateRequest, long>> logger,
            IGiftCardService service)
            : base(logger, service, service)
        {
        }
    }
}
