using AutoMapper;
using FurnitureStore.Models.Product;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class ProductService : BaseCRUDService<Models.Product.Product, Database.Product, ProductSearchObject,
        ProductInsertRequest, ProductUpdateRequest, long>, IProductService
    {
        public ProductService( AppDbContext context, IMapper mapper) : base(context, mapper) {
        }


        public override IQueryable<Database.Product> AddFilter(IQueryable<Database.Product> query, ProductSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                query = query.Where(x => x.Name.StartsWith(search.Name));
            }

            return base.AddFilter(query, search);
        }
    }

}
