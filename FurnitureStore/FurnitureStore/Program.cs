using AutoMapper;
using FurnitureStore.Configuration;
using FurnitureStore.Filters;
using FurnitureStore.Services;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.Services;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddTransient<ICategoryService, CategoryService>();
builder.Services.AddTransient<ISubcategoryService, SubcategoryService>();
builder.Services.AddTransient<IProductService>((serviceProvider) => {
    var context = serviceProvider.GetRequiredService<AppDbContext>();
    var mapper = serviceProvider.GetRequiredService<IMapper>();
    var logger = serviceProvider.GetRequiredService<ILogger<ProductService>>();
    var imagesDirectory = Path.Combine(builder.Environment.WebRootPath, "images");
    return new ProductService(context, mapper, logger, imagesDirectory);
});
builder.Services.AddTransient<IProductPictureService, ProductPictureService>();
builder.Services.AddTransient<IProductReservationService, ProductReservationService>();
builder.Services.AddTransient<IProductReservationItemService, ProductReservationItemService>();
builder.Services.AddTransient<IOrderService, OrderService>();
builder.Services.AddTransient<IOrderItemService, OrderItemService>();
builder.Services.AddTransient<IReportService, ReportService>();
builder.Services.AddTransient<IPromotionService, PromotionService>();
builder.Services.AddTransient<ICustomFurnitureReservation, CustomFurnitureReservationService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IPaymentOrderService, PaymentOrderService>();

builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<IGiftCardService, GiftCardService>();

builder.Services.AddTransient<IWishListService, WishListService>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilters>();
})
.AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddEFCoreInfrastructure(builder.Configuration);
builder.Services.AddIdentityInfrastructure(builder.Configuration);
builder.Services.AddSwaggerConfiguration();
builder.Services.AddAutoMapper(typeof(ICityService));

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Authorization");

});

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

// Enable static files middleware
app.UseStaticFiles();

// Ensure images directory exists
var webRootPath = app.Environment.WebRootPath;
var imagesPath = Path.Combine(webRootPath, "images");

if (!Directory.Exists(imagesPath))
{
    try
    {
        Directory.CreateDirectory(imagesPath);
        Console.WriteLine($"Created directory: {imagesPath}");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error creating directory: {ex.Message}");
    }
}

app.MapControllers();
app.SeedData();
using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var conn = dataContext.Database.GetConnectionString();
    dataContext.Database.Migrate();
}

app.Run();
