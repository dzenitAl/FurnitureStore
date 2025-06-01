using AutoMapper;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace FurnitureStore.Services.Services
{
    public abstract class BaseImageHandlingService<TModel, TEntity, TId> : IBaseImageHandlingService<TModel, TId>
        where TEntity : class
        where TModel : class
    {
        protected readonly AppDbContext _context;
        protected readonly IMapper _mapper;
        protected readonly IProductPictureService _productPictureService;
        protected readonly string _entityType;

        protected BaseImageHandlingService(
            AppDbContext context,
            IMapper mapper,
            IProductPictureService productPictureService,
            string entityType)
        {
            _context = context;
            _mapper = mapper;
            _productPictureService = productPictureService;
            _entityType = entityType;
        }

        public virtual async Task<TModel> UpdateImage(TId id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return default;

            var picture = await _productPictureService.AddEntityImageAsync(_entityType, Convert.ToInt64(id), file);
            
            var result = _mapper.Map<TModel>(entity);
            SetImageId(result, picture.Id);
            
            return result;
        }

        public virtual async Task<bool> DeleteImage(TId id)
        {
            return await _productPictureService.DeleteEntityImageAsync(_entityType, Convert.ToInt64(id));
        }

        public virtual async Task<TModel> AddImage(TId id, IFormFile file)
        {
            var entity = await FindEntity(id);
            if (entity == null)
                return default;

            var picture = await _productPictureService.AddEntityImageAsync(_entityType, Convert.ToInt64(id), file);
            
            var result = _mapper.Map<TModel>(entity);
            SetImageId(result, picture.Id);
            
            return result;
        }

        protected abstract Task<TEntity> FindEntity(TId id);
        protected abstract void SetImageId(TModel model, long imageId);
    }
} 