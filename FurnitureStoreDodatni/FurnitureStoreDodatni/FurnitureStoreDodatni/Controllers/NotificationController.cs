using FurnitureStoreDodatni.Dtos.Notification;
using FurnitureStoreDodatni.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Connections;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace FurnitureStoreDodatni.Controllers
{ 
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private INotificationService _notificationService;
        public NotificationController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        [HttpGet]
        public virtual async Task<List<Dtos.Notification.Notification>> Get([FromQuery] NotificationSearchObject notificationSearch)
        {
            var result = await _notificationService.Get(notificationSearch);
            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ"
            };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "notifications",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);


            var json = JsonConvert.SerializeObject(result);

            var body = Encoding.UTF8.GetBytes(json);

            Console.WriteLine($"Sending notifications: {json}");

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "notifications",

                                 body: body);
            return result;
        }
    }
}