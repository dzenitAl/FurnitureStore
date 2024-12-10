using FurnitureStore.Configuration;
using FurnitureStore.Filters;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;
using FurnitureStore.Services.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

builder.Services.AddTransient<ICategoryService, CategoryService>();
builder.Services.AddTransient<ISubcategoryService, SubcategoryService>();
builder.Services.AddTransient<IProductService, ProductService>();
builder.Services.AddTransient<IProductPictureService, ProductPictureService>();
builder.Services.AddTransient<IProductReservationService, ProductReservationService>();
builder.Services.AddTransient<IProductReservationItemService, ProductReservationItemService>();
builder.Services.AddTransient<IOrderService, OrderService>();
builder.Services.AddTransient<IOrderItemService, OrderItemService>();
builder.Services.AddTransient<IReportService, ReportService>();
builder.Services.AddTransient<IPromotionService, PromotionService>();
builder.Services.AddTransient<ICustomFurnitureReservation, CustomFurnitureReservationService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();

builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<IGiftCardService, GiftCardService>();

builder.Services.AddTransient<IWishListService, WishListService>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilters>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddEFCoreInfrastructure(builder.Configuration);
builder.Services.AddIdentityInfrastructure(builder.Configuration);
builder.Services.AddSwaggerConfiguration();
builder.Services.AddAutoMapper(typeof(ICityService));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Authorization");

});

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles(); 

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var conn = dataContext.Database.GetConnectionString();
    dataContext.Database.Migrate();
}

app.Run();
