using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class SubcategoryService :
        ImageEnabledCRUDService<
            Models.Subcategory.Subcategory,
            Database.Subcategory,
            SubcategorySearchObject,
            Models.Subcategory.SubcategoryRequest,
            Models.Subcategory.SubcategoryRequest>,
        ISubcategoryService
    {
        public SubcategoryService(
            AppDbContext context,
            IMapper mapper,
            IProductPictureService productPictureService)
            : base(context, mapper, productPictureService, "Subcategory")
        {
        }

        protected override DbSet<Database.Subcategory> EntityDbSet => _context.Subcategories;

        protected override void SetImageId(Models.Subcategory.Subcategory model, long imageId)
        {
            model.ImageId = imageId;
        }
        
        protected override void SetImagePath(Models.Subcategory.Subcategory model, string path)
        {
            model.ImagePath = path;
        }
        
        public override async Task<Models.Subcategory.Subcategory> GetById(long id)
        {
            var model = await base.GetById(id);
            return await EnrichWithImageData(model, id);
        }

        public override async Task<PagedResult<Models.Subcategory.Subcategory>> Get(SubcategorySearchObject? search = null)
        {
            var result = await base.Get(search);

            if (result?.Result != null)
    {
        var ids = result.Result.Select(x => x.Id).ToList();
        var pictures = await _context.ProductPictures
            .Where(p => p.EntityType == "Subcategory" && ids.Contains(p.EntityId))
            .ToDictionaryAsync(p => p.EntityId, p => new { p.Id, p.ImagePath });

        foreach (var item in result.Result)
        {
            if (pictures.TryGetValue(item.Id, out var pictureInfo))
            {
                item.ImageId = pictureInfo.Id;
                        item.ImagePath = pictureInfo.ImagePath;
                    }
                }
            }

            return result;
        }
    }
}
