using AutoMapper;
using FurnitureStore.Models.Shared;
using FurnitureStore.Services.Database;
using Microsoft.Extensions.DependencyInjection;

namespace FurnitureStore.Services.ProductStateMachine
{
    public class BaseState
    {
        protected AppDbContext _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Models.Product.Product> Insert(Models.Product.ProductInsertRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Models.Product.Product> Update(long id, Models.Product.ProductUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Models.Product.Product> Activate(long id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Models.Product.Product> Hide(long id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Models.Product.Product> Delete(long id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialProductState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftProductState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveProductState>();
                    break;

                default:
                    throw new UserException("Not allowed");
            }
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }

    }
}
