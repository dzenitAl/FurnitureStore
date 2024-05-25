using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public class CategoryService : BaseCRUDService<Models.Category.Category, Database.Category, CategorySearchObject, Models.Category.CategoryRequest, Models.Category.CategoryRequest, long>, ICategoryService
    {
        public CategoryService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Database.Category> AddFilter(IQueryable<Database.Category> query, CategorySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.StartsWith(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.Name.Contains(search.FTS));
            }

            return base.AddFilter(query, search);
        }

    }
}
