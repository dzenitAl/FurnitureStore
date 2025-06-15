using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class CategoryService : ImageEnabledCRUDService<
    Models.Category.Category,
    Database.Category,
    CategorySearchObject,
    Models.Category.CategoryRequest,
    Models.Category.CategoryRequest>,
    ICategoryService
    {
        public CategoryService(AppDbContext context, IMapper mapper, IProductPictureService pictureService)
            : base(context, mapper, pictureService, "Category")
        {
        }

        protected override DbSet<Database.Category> EntityDbSet => _context.Categories;

        protected override void SetImageId(Models.Category.Category model, long imageId) =>
            model.ImageId = imageId;

        protected override void SetImagePath(Models.Category.Category model, string path) =>
            model.ImagePath = path;

        public override async Task<Models.Category.Category> GetById(long id)
        {
            var entity = await _context.Categories.FindAsync(id);
            if (entity == null)
                return null;

            var result = _mapper.Map<Models.Category.Category>(entity);
            return await EnrichWithImageData(result, id);
        }

        public override async Task<Models.Category.Category> Insert(Models.Category.CategoryRequest insert)
        {
            var result = await base.Insert(insert);

            if (insert.ImageFile != null)
            {
                result = await AddImage(result.Id, insert.ImageFile);
            }

            return result;
        }

        public override async Task<Models.Category.Category> Update(long id, Models.Category.CategoryRequest update)
        {
            var result = await base.Update(id, update);

            if (update.ImageFile != null)
            {
                result = await UpdateImage(id, update.ImageFile);
            }

            return result;
        }

        public override IQueryable<Database.Category> AddFilter(IQueryable<Database.Category> query, CategorySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
                filteredQuery = filteredQuery.Where(x => x.Name.StartsWith(search.Name));

            if (!string.IsNullOrWhiteSpace(search?.FTS))
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.FTS));

            return filteredQuery;
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

