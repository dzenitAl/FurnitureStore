using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductPictureController : BaseCRUDController<Models.ProductPicture.ProductPicture, BaseSearchObject,
        Models.ProductPicture.ProductPictureInsertRequest, Models.ProductPicture.ProductPictureUpdateRequest, long>
    {
        public ProductPictureController(ILogger<BaseController<Models.ProductPicture.ProductPicture, BaseSearchObject, long>>
            logger, IProductPictureService service) : base(logger, service)
        {

        }
    }
}
