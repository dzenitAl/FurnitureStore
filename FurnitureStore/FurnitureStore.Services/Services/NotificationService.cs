using AutoMapper;
using FurnitureStore.Models.Notification;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace FurnitureStore.Services.Services
{
    public class NotificationService : BaseCRUDService<Models.Notification.Notification, Database.Notification, NotificationSearchObject, NotificationInsertRequest, NotificationUpdateRequest, long>, INotificationService
    {
        public NotificationService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Notification> AddFilter(IQueryable<Database.Notification> query, NotificationSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Heading))
            {
                filteredQuery = filteredQuery.Where(x => x.Heading.Contains(search.Heading));
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Notification> AddInclude(IQueryable<Database.Notification> query, NotificationSearchObject? search = null)
        {
            query = query.Include("Admin");
            return base.AddInclude(query, search);
        }

        public async Task<Models.Notification.Notification> MarkAsRead(long id)
        {
            var entity = await _context.Notifications.FindAsync(id);
            if (entity == null)
                throw new Exception("Notification not found");

            var updateRequest = new NotificationUpdateRequest
            {
                IsRead = true,
                Content = entity.Content,
                Heading = entity.Heading,
                CreatedAt = entity.CreatedAt
            };

            return await Update(id, updateRequest);
        }
    }
}
