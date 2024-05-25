using AutoMapper;
using FurnitureStore.Models.Product;

namespace FurnitureStore.Services.ProductStateMachine
{
    public class InitialProductState : BaseState
    {
        public InitialProductState(IServiceProvider serviceProvider, Database.AppDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Product> Insert(ProductInsertRequest request)
        {
            //TODO: EF CALL
            var set = _context.Set<Database.Product>();

            var entity = _mapper.Map<Database.Product>(request);

            entity.StateMachine = "draft";

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Product>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
