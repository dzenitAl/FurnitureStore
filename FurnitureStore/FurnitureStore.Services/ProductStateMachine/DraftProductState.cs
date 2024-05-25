using AutoMapper;
using FurnitureStore.Models.Product;
using FurnitureStore.Models.Shared;
using Microsoft.Extensions.Logging;

namespace FurnitureStore.Services.ProductStateMachine
{
    public class DraftProductState : BaseState
    {
        protected ILogger<DraftProductState> _logger;
        public DraftProductState(ILogger<DraftProductState> logger, IServiceProvider serviceProvider, Database.AppDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
            _logger = logger;
        }

        public override async Task<Product> Update(long id, ProductUpdateRequest request)
        {
            var set = _context.Set<Database.Product>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            if (entity.Price < 0)
            {
                throw new Exception("Cijena ne moze biti u minusu");
            }

            if (entity.Price < 1)
            {
                throw new UserException("Cijena ispod minimuma");
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<Product>(entity);
        }

        public override async Task<Product> Activate(long id)
        {
            _logger.LogInformation($"Aktivacija proizvoda: {id}");

            _logger.LogWarning($"W: Aktivacija proizvoda: {id}");

            _logger.LogError($"E: Aktivacija proizvoda: {id}");

            var set = _context.Set<Database.Product>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            await _context.SaveChangesAsync();

            return _mapper.Map<Product>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");

            return list;
        }
    }
}
