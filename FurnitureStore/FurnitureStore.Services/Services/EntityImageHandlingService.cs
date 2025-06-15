using AutoMapper;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Http;

namespace FurnitureStore.Services.Services
{
    public class EntityImageHandlingService<TModel, TEntity>
        where TEntity : class
        where TModel : class
    {
        protected readonly AppDbContext _context;
        protected readonly IMapper _mapper;
        protected readonly IProductPictureService _productPictureService;
        protected readonly string _entityType;

        public EntityImageHandlingService(
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

        public virtual async Task<TModel> AddImage(TEntity entity, long entityId, IFormFile file, Action<TModel, long> setImageId, Action<TModel, string> setImagePath = null)
        {
            if (entity == null)
                return null;

            var picture = await _productPictureService.AddEntityImageAsync(_entityType, entityId, file);
            
            var result = _mapper.Map<TModel>(entity);
            setImageId(result, picture.Id);
            setImagePath?.Invoke(result, picture.ImagePath);
            
            return result;
        }

        public virtual async Task<bool> DeleteImage(long entityId)
        {
            return await _productPictureService.DeleteEntityImageAsync(_entityType, entityId);
        }

        public virtual async Task<TModel> UpdateImage(TEntity entity, long entityId, IFormFile file, Action<TModel, long> setImageId, Action<TModel, string> setImagePath = null)
        {
            return await AddImage(entity, entityId, file, setImageId, setImagePath);
        }

        public virtual async Task<TModel> EnrichWithImageData(TModel model, long entityId, Action<TModel, long> setImageId, Action<TModel, string> setImagePath = null)
        {
            var picture = await _productPictureService.GetByEntityAsync(_entityType, entityId);
            if (picture != null)
            {
                setImageId(model, picture.Id);
                setImagePath?.Invoke(model, picture.ImagePath);
            }
            return model;
        }
    }
} 