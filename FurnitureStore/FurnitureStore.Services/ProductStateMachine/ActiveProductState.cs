using AutoMapper;
using FurnitureStore.Models.Product;

namespace FurnitureStore.Services.ProductStateMachine
{
    public class ActiveProductState : BaseState
    {
        public ActiveProductState(IServiceProvider serviceProvider, Database.AppDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Product> Hide(long id)
        {
            var set = _context.Set<Database.Product>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Product>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Hide");

            return list;
        }
    }
}
