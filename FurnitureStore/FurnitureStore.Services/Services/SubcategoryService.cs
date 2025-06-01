using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class SubcategoryService : 
        BaseCRUDService<Models.Subcategory.Subcategory,
        Database.Subcategory, SubcategorySearchObject,
        Models.Subcategory.SubcategoryRequest, Models.Subcategory.SubcategoryRequest, long>, 
        ISubcategoryService
    {
        private readonly IProductPictureService _productPictureService;

        public SubcategoryService(
            AppDbContext context, 
            IMapper mapper,
            IProductPictureService productPictureService) : base(context, mapper)
        {
            _productPictureService = productPictureService;
        }

        protected async Task<Database.Subcategory> FindEntity(long id)
        {
            return await _context.Subcategories.FindAsync(id);
        }

        protected void SetImageId(Models.Subcategory.Subcategory model, long imageId)
        {
            model.ImageId = imageId;
        }

        public override async Task<Models.Subcategory.Subcategory> GetById(long id)
        {
            var entity = await _context.Subcategories.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.Subcategory.Subcategory>(entity);
            var picture = await _productPictureService.GetByEntityAsync("Subcategory", id);
            result.ImageId = picture?.Id;
            return result;
        }

        public override async Task<PagedResult<Models.Subcategory.Subcategory>> Get(SubcategorySearchObject? search = null)
        {
            var result = await base.Get(search);
            
            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "Subcategory" && ids.Contains(p.EntityId))
                    .ToDictionaryAsync(p => p.EntityId, p => p.Id);
                
                foreach (var item in result.Result)
                {
                    if (pictures.TryGetValue(item.Id, out var pictureId))
                        item.ImageId = pictureId;
                }
            }
            
            return result;
        }

        public async Task<Models.Subcategory.Subcategory> UpdateImage(long id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync("Subcategory", id, file);
            
            var result = _mapper.Map<Models.Subcategory.Subcategory>(entity);
            SetImageId(result, picture.Id);
            
            return result;
        }

        public async Task<bool> DeleteImage(long id)
        {
            return await _productPictureService.DeleteEntityImageAsync("Subcategory", id);
        }
    }
}
