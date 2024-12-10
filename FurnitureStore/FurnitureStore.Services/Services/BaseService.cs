using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;


namespace FurnitureStore.Services.Services
{
    public class BaseService<T, TDb, TSearch, TId> : IService<T, TSearch, TId> where TDb : class where T : class where TSearch : BaseSearchObject
    {

        protected AppDbContext _context;
        protected IMapper _mapper { get; set; }
        public BaseService(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> Get(TSearch? search = null)
        {
            


            try
            {
                var query = _context.Set<TDb>().AsQueryable();

                PagedResult<T> result = new PagedResult<T>();

                query = AddFilter(query, search);
                query = AddInclude(query, search);

                result.Count = await query.CountAsync();

                if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
                {
                    query = query.Take(search.PageSize.Value).Skip(search.Page.Value * search.PageSize.Value);
                }
                var list = await query.ToListAsync();
                var tmp = _mapper.Map<List<T>>(list);
                result.Result = tmp;
                return result;

            }
            catch (Exception ex) { }
            return null;
           
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }
        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetById(TId id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
        public virtual async Task Delete(TId id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            _context.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}
