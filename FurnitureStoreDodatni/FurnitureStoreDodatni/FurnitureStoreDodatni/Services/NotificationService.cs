using AutoMapper;
using FurnitureStoreDodatni.Database;
using FurnitureStoreDodatni.Dtos.Notification;
using Microsoft.EntityFrameworkCore;
using System;

namespace FurnitureStoreDodatni.Services
{
    public class NotificationService : INotificationService
    {
        private AppDbContext _appDbContext;
        private IMapper _mapper;
        public NotificationService(AppDbContext appDbContext, IMapper mapper)
        {
            _appDbContext = appDbContext;
            _mapper = mapper;
        }

        public async Task<List<Dtos.Notification.Notification>> Get(NotificationSearchObject notificationSearch)
        {
            var notifications = await _appDbContext.Notifications.ToListAsync();

            if (notificationSearch != null)
            {
                if (notificationSearch.AdminId != null)
                    notifications = notifications.Where(m => m.AdminId == notificationSearch.AdminId).ToList();

                if (!string.IsNullOrWhiteSpace(notificationSearch?.Heading))
                    notifications = notifications.Where(x => x.Heading.Contains(notificationSearch.Heading)).ToList();
            }

            return _mapper.Map<List<Dtos.Notification.Notification>>(notifications);

        }
    }
}