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
            query = query.Include("Section").Include("Admin");
            return base.AddInclude(query, search);
        }
    }

}
