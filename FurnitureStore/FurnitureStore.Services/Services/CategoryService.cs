using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class CategoryService : 
        BaseCRUDService<Models.Category.Category, Database.Category, CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest, long>,
        ICategoryService
    {
        private readonly IProductPictureService _productPictureService;

        public CategoryService(
            AppDbContext context,
            IMapper mapper,
            IProductPictureService productPictureService) 
            : base(context, mapper)
        {
            _productPictureService = productPictureService;
        }

        protected  async Task<Database.Category> FindEntity(long id)
        {
            return await _context.Categories.FindAsync(id);
        }

        protected  void SetImageId(Models.Category.Category model, long imageId)
        {
            model.ImageId = imageId;
        }

        public override IQueryable<Database.Category> AddFilter(IQueryable<Database.Category> query, CategorySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.StartsWith(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.FTS));
            }

            return filteredQuery;
        }

        public async Task<Models.Category.Category> AddImage(long id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync("Category", id, file);
            
            var result = _mapper.Map<Models.Category.Category>(entity);
            SetImageId(result, picture.Id);
            result.ImagePath = picture.ImagePath;
            
            return result;
        }

  
        public override async Task<Models.Category.Category> GetById(long id)
        {
            var entity = await _context.Categories.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.Category.Category>(entity);

            var picture = await _productPictureService.GetByEntityAsync("Category", id);
            if (picture != null)
            {
                result.ImageId = picture.Id;
                result.ImagePath = picture.ImagePath;
            }

            return result;
        }


        public override async Task<PagedResult<Models.Category.Category>> Get(CategorySearchObject? search = null)
        {
            var result = await base.Get(search);
            
            if (result?.Result != null)
            {
                var ids = result.Result.Select(x => x.Id).ToList();
                var pictures = await _context.ProductPictures
                    .Where(p => p.EntityType == "Category" && ids.Contains(p.EntityId))
                    .ToDictionaryAsync(p => p.EntityId, p => new { p.Id, p.ImagePath });
                
                foreach (var item in result.Result)
                {
                    if (pictures.TryGetValue(item.Id, out var picture))
                    {
                        item.ImageId = picture.Id;
                        item.ImagePath = picture.ImagePath;
                    }
                }
            }
            
            return result;
        }

        public async Task<Models.Category.Category> UpdateImage(long id, IFormFile imageFile)
        {
            var entity = await _context.Categories.FindAsync(id);
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync("Category", id, imageFile);
            
            var result = _mapper.Map<Models.Category.Category>(entity);
            result.ImageId = picture.Id;
            result.ImagePath = picture.ImagePath;
            
            return result;
        }

        public async Task<bool> DeleteImage(long id)
        {
            return await _productPictureService.DeleteEntityImageAsync("Category", id);
        }

        public override async Task<Models.Category.Category> Insert(Models.Category.CategoryRequest insert)
        {
            var result = await base.Insert(insert);
            
            if (insert.ImageFile != null)
            {
                var picture = await _productPictureService.AddEntityImageAsync("Category", result.Id, insert.ImageFile);
                result.ImageId = picture.Id;
            }
            
            return result;
        }

        public override async Task<Models.Category.Category> Update(long id, Models.Category.CategoryRequest update)
        {
            var result = await base.Update(id, update);
            
            if (update.ImageFile != null)
            {
                var picture = await _productPictureService.AddEntityImageAsync("Category", id, update.ImageFile);
                result.ImageId = picture.Id;
            }
            
            return result;
        }
    }
}
