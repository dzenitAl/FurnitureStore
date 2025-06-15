using AutoMapper;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

public abstract class ImageEnabledCRUDService<TModel, TEntity, TSearch, TInsert, TUpdate> :
    BaseCRUDService<TModel, TEntity, TSearch, TInsert, TUpdate, long>
    where TEntity : class
    where TModel : class
     where TSearch : FurnitureStore.Models.SearchObjects.BaseSearchObject
{
    private readonly EntityImageHandlingService<TModel, TEntity> _imageHandler;
    private readonly string _entityType;

    protected ImageEnabledCRUDService(AppDbContext context, IMapper mapper, IProductPictureService pictureService, string entityType)
        : base(context, mapper)
    {
        _imageHandler = new EntityImageHandlingService<TModel, TEntity>(context, mapper, pictureService, entityType);
        _entityType = entityType;
    }

    protected abstract DbSet<TEntity> EntityDbSet { get; }
    protected abstract void SetImageId(TModel model, long imageId);
    protected virtual void SetImagePath(TModel model, string path) {}

    public virtual async Task<TModel> AddImage(long id, IFormFile file)
    {
        var entity = await EntityDbSet.FindAsync(id);
        return await _imageHandler.AddImage(entity, id, file, SetImageId, SetImagePath);
    }

    public virtual async Task<TModel> UpdateImage(long id, IFormFile file)
    {
        var entity = await EntityDbSet.FindAsync(id);
        return await _imageHandler.UpdateImage(entity, id, file, SetImageId, SetImagePath);
    }

    public virtual async Task<bool> DeleteImage(long id)
    {
        return await _imageHandler.DeleteImage(id);
    }

    public virtual async Task<TModel> EnrichWithImageData(TModel model, long id)
    {
        return await _imageHandler.EnrichWithImageData(model, id, SetImageId, SetImagePath);
    }
}
