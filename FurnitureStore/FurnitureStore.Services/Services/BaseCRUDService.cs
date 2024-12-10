using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;

namespace FurnitureStore.Services.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate, TId> : BaseService<T, TDb, TSearch, TId> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {
        }
        public virtual async Task BeforeUpdate(TDb entity, TUpdate update)
        {
        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            TDb entity = _mapper.Map<TDb>(insert);

            set.Add(entity);
            await BeforeInsert(entity, insert);

            try
            {
                await _context.SaveChangesAsync();

            }
            catch (Exception ex)
            {

            }
            return _mapper.Map<T>(entity);
        }


        public virtual async Task<T> Update(TId id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);
            await BeforeUpdate(entity, update);
            _mapper.Map(update, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

    }
}
