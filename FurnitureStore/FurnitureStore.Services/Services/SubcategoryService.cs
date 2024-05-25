using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class SubcategoryService : BaseCRUDService<Models.Subcategory.Subcategory,
        Database.Subcategory, SubcategorySearchObject,
        Models.Subcategory.SubcategoryRequest, Models.Subcategory.SubcategoryRequest, long>, ISubcategoryService
    {
        public SubcategoryService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
