using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
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

        [HttpPost("uploadImages")]
        public async Task<IActionResult> UploadProductPictures([FromForm] long productId, [FromForm] IFormFileCollection images)
        {
            if (productId <= 0)
            {
                return BadRequest("Invalid product ID.");
            }

            if (images == null || images.Count == 0)
            {
                return BadRequest("No images provided.");
            }

            var productPictures = new List<Models.ProductPicture.ProductPicture>();

            try
            {
                foreach (var image in images)
                {
                    if (image.Length == 0)
                    {
                        return BadRequest("Invalid image file.");
                    }

                    var productPicture = await ((IProductPictureService)_service).AddProductPictureAsync(productId, image);
                    productPictures.Add(productPicture);
                }

                return Ok(new { Message = "Images uploaded successfully", productPictures });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }


    }
}
