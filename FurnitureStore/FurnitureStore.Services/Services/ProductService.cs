using AutoMapper;
using FurnitureStore.Models.Product;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.ProductStateMachine;

namespace FurnitureStore.Services.Services
{
    public class ProductService : BaseCRUDService<Models.Product.Product, Database.Product, ProductSearchObject,
        ProductInsertRequest, ProductUpdateRequest, long>, IProductService
    {
        public BaseState _baseState { get; set; }
        public ProductService(BaseState baseState, AppDbContext context, IMapper mapper) : base(context, mapper) {
            _baseState = baseState;
        }

        public override Task<Models.Product.Product> Insert(ProductInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);

        }

        public override async Task<Models.Product.Product> Update(long id, ProductUpdateRequest update)
        {
            var entity = await _context.Products.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }
      
        public async Task<Models.Product.Product> Activate(long id)
        {
            var entity = await _context.Products.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Models.Product.Product> Hide(long id)
        {
            var entity = await _context.Products.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }
        public async Task<List<string>> AllowedActions(long id)
        {
            var entity = await _context.Products.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }
    }

}
