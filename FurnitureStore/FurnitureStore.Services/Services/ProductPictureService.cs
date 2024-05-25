using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class ProductPictureService : BaseCRUDService<Models.ProductPicture.ProductPicture, ProductPicture, BaseSearchObject,
        Models.ProductPicture.ProductPictureInsertRequest, Models.ProductPicture.ProductPictureUpdateRequest, long>, IProductPictureService
    {
        public ProductPictureService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
