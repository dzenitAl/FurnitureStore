using FurnitureStore.Models.Enums;
using FurnitureStore.Services.Database;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Text;

namespace FurnitureStore.Configuration
{
    public static class EFCoreConfiguration
    {
        public static void AddEFCoreInfrastructure(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
                b => b.MigrationsAssembly(typeof(AppDbContext).Assembly.FullName))
            );
        }



        public static void SeedData(this IApplicationBuilder app)
        {
            using (var serviceScope = app.ApplicationServices.GetRequiredService<IServiceScopeFactory>().CreateScope())
            {
                var context = serviceScope.ServiceProvider.GetService<AppDbContext>();
                context.Database.SetCommandTimeout(TimeSpan.FromMinutes(3));
                context.Database.Migrate();

                if (!context.Cities.Any())
                {
                    SeedCities(context);
                }

                if (!context.Categories.Any())
                {
                    SeedCategories(context);
                }

                if (!context.Subcategories.Any())
                {
                    SeedSubcategories(context);
                }

                if (!context.Users.Any())
                {
                    SeedUsers(context, serviceScope);
                }

                if (!context.Roles.Any())
                {
                    SeedRoles(context);
                }

                if (!context.Products.Any())
                {
                    SeedProducts(context);
                }

                if (!context.ProductReservations.Any())
                {
                    SeedProductReservations(context);
                }

                if (!context.ProductReservationItems.Any())
                {
                    SeedProductReservationItems(context);
                }

                if (!context.CustomFurnitureReservations.Any())
                {
                    SeedCustomFurnitureReservations(context);
                }

                if (!context.Notifications.Any())
                {
                    SeedNotifications(context);
                }

                if (!context.Promotions.Any())
                {
                    SeedPromotions(context);
                }

                if (!context.GiftCards.Any())
                {
                    SeedGiftCards(context);
                }

                if (!context.Orders.Any())
                {
                    SeedOrders(context);
                }

                if (!context.OrderItems.Any())
                {
                    SeedOrderItems(context);
                }

                if (!context.WishLists.Any())
                {
                    SeedWishLists(context);
                }


                if (!context.Reports.Any())
                {
                    SeedReports(context);
                }

                if (!context.DecorativeItems.Any())
                {
                    SeedDecorationItems(context);
                }

                if (!context.ProductPictures.Any())
                {
                    SeedProductPictures(context);
                    SeedDecorativeItemPictures(context);
                }
            }

        }



        private static void SeedCities(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Cities ON;

    INSERT INTO Cities (Id, Name, CreatedAt)
    VALUES
    (1, N'Mostar', CAST(N'2024-12-12' AS DateTime2)),
    (2, N'Visoko', CAST(N'2024-12-12' AS DateTime2)),
    (3, N'Sarajevo', CAST(N'2024-12-12' AS DateTime2)),
    (4, N'Zenica', CAST(N'2024-12-12' AS DateTime2));

    SET IDENTITY_INSERT Cities OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedRoles(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Roles ON;

    INSERT INTO Roles (Id, Name)
    VALUES
    (N'admin', N'Admin'),
    (N'customer', N'Customer');

    SET IDENTITY_INSERT Roles OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedUsers(AppDbContext context, IServiceScope scope)
        {
            var userManager = scope.ServiceProvider.GetService<UserManager<User>>();

            if (userManager == null)
                return;

            var admin = new User
            {
                Id = "ff697def-9c3d-4b5a-84e2-e0ff755e9bc0",
                Username = "admin",
                Email = "admin@example.com",
                FirstName = "Admin",
                LastName = "User",
                BirthDate = DateTime.Parse("1999-12-12"),
                Gender = Gender.Male,
                PhoneNumber = "062245878",
                EmailConfirmed = true,
                SecurityStamp = Guid.NewGuid().ToString(),
                CreatedById = null,
                CreatedAt = DateTime.Now,
                CityId = 1
            };

            var existingAdmin = userManager.FindByNameAsync(admin.Username).Result;
            if (existingAdmin == null)
            {
                var result = userManager.CreateAsync(admin, "Admin123!").Result;
                if (result.Succeeded)
                    userManager.AddToRoleAsync(admin, "Admin").Wait();
            }

            var customer = new User
            {
                Id = "8b519724-b111-42d5-a7b5-de06b7dbbbb3",
                Username = "customer",
                Email = "customer@example.com",
                FirstName = "Customer",
                LastName = "User",
                BirthDate = DateTime.Parse("1995-05-05"),
                Gender = Gender.Female,
                PhoneNumber = "061985456",
                EmailConfirmed = true,
                SecurityStamp = Guid.NewGuid().ToString(),
                CreatedById = null,
                CreatedAt = DateTime.Now,
                CityId = 1
            };

            var existingCustomer = userManager.FindByNameAsync(customer.Username).Result;
            if (existingCustomer == null)
            {
                var result = userManager.CreateAsync(customer, "Customer123!").Result;
                if (result.Succeeded)
                    userManager.AddToRoleAsync(customer, "Customer").Wait();
            }
        }

        private static void SeedCategories(AppDbContext context)
        {
            var sqlCommand = @"
        SET IDENTITY_INSERT Categories ON;

        INSERT INTO Categories (Id, Name, Description, CreatedAt, ImagePath)
        VALUES
        (1, N'Dnevni boravak', N'Kategorija za namještaj namijenjen dnevnim boravcima', CAST(N'2024-12-10' AS DateTime2), N'/images/category_living_room.jpg'),
        (2, N'Spavaća soba', N'Kategorija za namještaj namijenjen spavaćim sobama', CAST(N'2024-12-10' AS DateTime2), N'/images/category_bedroom.jpg'),
        (3, N'Kancelarijski namještaj', N'Kategorija za kancelarijski namještaj', CAST(N'2024-12-10' AS DateTime2), N'/images/category_office.jpg');

        SET IDENTITY_INSERT Categories OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedSubcategories(AppDbContext context)
        {
            var sqlCommand = @"
        SET IDENTITY_INSERT Subcategories ON;

        INSERT INTO Subcategories (Id, Name, CategoryId, CreatedAt, ImagePath)
        VALUES
        (1, N'Sofe', 1, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_sofas.jpg'),
        (2, N'Klub stolovi', 1, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_tables.jpg'),
        (3, N'Kreveti', 2, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_bed.jpg'),
        (4, N'Ormari', 2, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_wardrobes.jpg'),
        (5, N'Radni stolovi', 3, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_desks.jpg'),
        (6, N'Kancelarijske stolice', 3, CAST(N'2024-12-10' AS DateTime2), N'/images/subcategory_chairs.jpg');

        SET IDENTITY_INSERT Subcategories OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }


        private static void SeedProducts(AppDbContext context)
        {
            var sqlCommand = @"
        SET IDENTITY_INSERT Products ON;

        INSERT INTO Products (Id, Name, Description, Price, Dimensions, IsAvailableInStore, IsAvailableOnline, SubcategoryId, CreatedAt, Barcode)
        VALUES
        (1, N'Sofa Model X', N'Elegantna sofa za dnevni boravak.', 900.00, N'200x90x80 cm', 1, 1, 1, CAST(N'2024-12-10' AS DateTime2), N'123456789012'),
        (2, N'Krevet Model Y', N'Udoban krevet za spavaću sobu.', 799.99, N'180x200 cm', 1, 1, 3, CAST(N'2024-12-10' AS DateTime2), N'234567890123'),
        (3, N'Klub sto Elegance', N'Moderan klub sto za dnevni boravak.', 249.50, N'120x60x45 cm', 1, 0, 2, CAST(N'2024-12-11' AS DateTime2), N'345678901234'),
        (4, N'Ormar Classic', N'Veliki ormar sa kliznim vratima.', 650.00, N'200x60x210 cm', 0, 1, 4, CAST(N'2024-12-11' AS DateTime2), N'456789012345'),
        (5, N'Radni sto ProDesk', N'Radni sto sa puno prostora za opremu.', 480.75, N'150x70x75 cm', 0, 0, 5, CAST(N'2024-12-11' AS DateTime2), N'567890123456'),
        (6, N'Kancelarijska stolica Ergo', N'Ergonomska stolica sa naslonima.', 320.00, N'60x60x110 cm', 1, 1, 6, CAST(N'2024-12-12' AS DateTime2), N'678901234567'),
        (7, N'Sofa L-Shape Comfort', N'L-oblikovana sofa sa prostorom za ležanje.', 1050.00, N'260x160x90 cm', 1, 0, 1, CAST(N'2024-12-12' AS DateTime2), N'789012345678'),
        (8, N'Noćni sto Elegant', N'Stofiran noćni sto sa fiokama.', 180.25, N'50x40x45 cm', 0, 1, 3, CAST(N'2024-12-12' AS DateTime2), N'890123456789'),
        (9, N'Klub sto Rustic', N'Drveni sto rustičnog izgleda.', 199.99, N'110x60x40 cm', 1, 1, 2, CAST(N'2024-12-13' AS DateTime2), N'901234567890'),
        (10, N'Ormar Compact', N'Kompaktan ormar za manje prostore.', 350.00, N'120x50x180 cm', 0, 0, 4, CAST(N'2024-12-13' AS DateTime2), N'012345678901');

        SET IDENTITY_INSERT Products OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedProductReservations(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT ProductReservations ON;

        INSERT INTO ProductReservations (Id, ReservationDate, Notes, CustomerId, CreatedAt, IsApproved)
        VALUES
    (1, CAST(N'2024-08-30T10:00:00.000' AS DateTime2), N'Rezervacija za test proizvod 1', '8b519724-b111-42d5-a7b5-de06b7dbbbb3', GETDATE(), 0),
    (2, CAST(N'2024-09-01T12:00:00.000' AS DateTime2), N'Rezervacija za proizvod 2 i 3', '8b519724-b111-42d5-a7b5-de06b7dbbbb3', GETDATE(), 1),
    (3, CAST(N'2024-09-05T14:30:00.000' AS DateTime2), N'Rezervacija za proizvod 4', '8b519724-b111-42d5-a7b5-de06b7dbbbb3', GETDATE(), 0);

    SET IDENTITY_INSERT ProductReservations OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedProductReservationItems(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT ProductReservationItems ON;

        INSERT INTO ProductReservationItems (Id, Quantity, ProductReservationId, ProductId, CreatedAt)
        VALUES
    (1, 2, 1, 1, GETDATE()), -- Sofa Model X
    (2, 1, 2, 2, GETDATE()), -- Krevet Model Y
    (3, 3, 2, 3, GETDATE()), -- Klub stolovi
    (4, 1, 3, 4, GETDATE()); -- Ormari

    SET IDENTITY_INSERT ProductReservationItems OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedPromotions(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Promotions ON;

    INSERT INTO Promotions (Id, Heading, Content, AdminId, StartDate, EndDate, CreatedAt, ImagePath)
    VALUES
    (1, N'Proljetno snizenje', N'Provjerite naše proljetno snizenje', N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), CAST(N'2025-09-28T00:00:00.0000000' AS DateTime2), CAST(N'2025-08-28T00:00:00.0000000' AS DateTime2), N'/images/promotion_1.jpg'),
    (2, N'Nova kolekcija', N'Provjerite našu novu kolekciju', N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', CAST(N'2025-08-28T00:00:00.0000000' AS DateTime2), CAST(N'2024-10-28T00:00:00.0000000' AS DateTime2), CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), N'/images/promotion_2.jpg'),
    (3, N'Zimska kolekcija', N'Provjerite našu zimsku kolekciju', N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', CAST(N'2025-08-28T00:00:00.0000000' AS DateTime2), CAST(N'2024-12-28T00:00:00.0000000' AS DateTime2), CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), N'/images/promotion_3.jpg');

    SET IDENTITY_INSERT Promotions OFF;

    -- Insert the many-to-many relationships
    INSERT INTO ProductPromotion (ProductsId, PromotionsId)
    VALUES
    (1, 1), (2, 1), (3, 1), (4, 1),  -- Summer Sale products
    (5, 2), (6, 2),                   -- New Collection products
    (7, 3), (8, 3);                   -- Winter Collection products
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedGiftCards(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT GiftCards ON;

    INSERT INTO GiftCards (Id, Name, CardNumber, Amount, ExpiryDate, IsActivated, CreatedAt, CreatedById, LastModified, LastModifiedBy, ImagePath)
    VALUES
    (1, N'Poklon kartica 50 BAM', N'1234-5678-9012-3456', 50, CAST(N'2024-08-31T00:00:00.0000000' AS DateTime2), 1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, N'/images/giftcard_50.jpg'),
    (2, N'Poklon kartica 100 BAM', N'1234-5678-9012-3457', 40, CAST(N'2025-08-31T00:00:00.0000000' AS DateTime2), 1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, N'/images/gift.jpg'),
    (3, N'Poklon kartica 200 BAM', N'1234-5678-9012-3458', 20, CAST(N'2025-08-31T00:00:00.0000000' AS DateTime2), 1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, N'/images/gift_card_1.jpg');

    SET IDENTITY_INSERT GiftCards OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedCustomFurnitureReservations(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT CustomFurnitureReservations ON;

    INSERT INTO CustomFurnitureReservations (Id, Note, ReservationDate, ReservationStatus, UserId, CreatedAt, CreatedById, LastModified, LastModifiedBy)
    VALUES
    (1, N'Rezervacija za custom namještaj za dnevni boravak', CAST(N'2024-09-28T00:00:00.0000000' AS DateTime2), 1, '8b519724-b111-42d5-a7b5-de06b7dbbbb3', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL),
    (2, N'Rezervacija za custom namještaj za kuhinju', CAST(N'2024-09-28T00:00:00.0000000' AS DateTime2), 1, '8b519724-b111-42d5-a7b5-de06b7dbbbb3', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL);

    SET IDENTITY_INSERT CustomFurnitureReservations OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedNotifications(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Notifications ON;

    INSERT INTO Notifications (Id, Heading, Content, AdminId, CreatedAt, CreatedById, LastModified, LastModifiedBy)
    VALUES
    (1, N'Nova promocija', N'Pregledajte novu promociju zimske rasprodaje na našem sajtu!', N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), NULL);
 
    SET IDENTITY_INSERT Notifications OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedOrders(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Orders ON;

    INSERT INTO Orders (Id, OrderDate, Delivery, TotalPrice, CustomerId, CreatedAt, IsApproved)
    VALUES
    (1, CAST(N'2024-08-27T00:00:00.0000000' AS DateTime2), 0, 400, '8b519724-b111-42d5-a7b5-de06b7dbbbb3', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), 1);

    SET IDENTITY_INSERT Orders OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedOrderItems(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT OrderItems ON;

    INSERT INTO OrderItems (Id, Quantity, OrderId, ProductId, CreatedAt)
    VALUES
    (1, 1, 1, 1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2));

    SET IDENTITY_INSERT OrderItems OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedWishLists(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT WishLists ON;

    INSERT INTO WishLists (Id, DateCreated, CustomerId, CreatedAt)
    VALUES
    (1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), '8b519724-b111-42d5-a7b5-de06b7dbbbb3', CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2));

    SET IDENTITY_INSERT WishLists OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedReports(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT Reports ON;

    INSERT INTO Reports (Id, GenerationDate, Content, AdminId, CustomerId, Month, Year, CreatedAt, CreatedById, ReportType, LastModified, LastModifiedBy)
    VALUES
    (1, CAST(N'2024-07-01T00:00:00.0000000' AS DateTime2), N'Monthly sales report for the previous month.', N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', '8b519724-b111-42d5-a7b5-de06b7dbbbb3', 7, 2024, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0', 1, CAST(N'2024-08-28T00:00:00.0000000' AS DateTime2), N'ff697def-9c3d-4b5a-84e2-e0ff755e9bc0');
    

    SET IDENTITY_INSERT Reports OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }
        private static void SeedDecorationItems(AppDbContext context)
        {
            var sqlCommand = @"
SET IDENTITY_INSERT DecorativeItems ON;

INSERT INTO DecorativeItems (Id, Name, Description, Price, StockQuantity, Material, Dimensions, Style, Color, IsFragile, CareInstructions, CategoryId, CreatedAt, IsAvailableInStore, IsAvailableOnline)
VALUES
(1, N'Vaza Elegance', N'Stilizirana keramička vaza sa zlatnim detaljima.', 45.00, 20, N'Keramika', N'15x15x30 cm', N'Moderni', N'Bijela/Zlatna', 1, N'Obrisati suhom krpom', 1, CAST(N'2024-12-10' AS DateTime2), 1, 1),
(2, N'Zidni sat Rustic', N'Dekorativni zidni sat u rustičnom stilu.', 60.00, 15, N'Drvo/Metal', N'40x40x5 cm', N'Rustični', N'Smeđa', 0, N'Povremeno obrisati prašinu', 1, CAST(N'2024-12-10' AS DateTime2), 1, 0),
(3, N'Svijećnjak Stakleni', N'Svijećnjak od stakla za elegantne večeri.', 25.99, 30, N'Staklo', N'10x10x25 cm', N'Klasični', N'Providno', 1, N'Pažljivo čistiti', 2, CAST(N'2024-12-10' AS DateTime2), 1, 1),
(4, N'Ukrasna figura Mjesec', N'Figura Mjeseca, kreirana od drveta.', 89.90, 10, N'Drvo', N'20x8x18 cm', N'Klasični', N'Crna', 0, N'Samo obrisati', 2, CAST(N'2024-12-10' AS DateTime2), 1, 1),
(5, N'Zidna dekoracija MetalArt', N'Moderna metalna zidna dekoracija.', 120.00, 5, N'Metal', N'100x50x3 cm', N'Apstraktni', N'Crna/Zlatna', 0, N'Očistiti suhom krpom', 3, CAST(N'2024-12-10' AS DateTime2), 1, 1),
(6, N'Jastuk Floral', N'Dekorativni jastuk sa cvjetnim uzorkom.', 18.50, 40, N'Tkanina', N'45x45 cm', N'Boho', N'Višebojna', 0, N'Prati na 30°C', 1, CAST(N'2024-12-10' AS DateTime2), 1, 1),
(7, N'Ukrasni pladanj MirrorLux', N'Pladanj sa ogledalom za ukrasne svrhe.', 35.00, 25, N'Metal/Staklo', N'30x20x2 cm', N'Moderni', N'Srebrna', 1, N'Obrisati mekom krpom', 2, CAST(N'2024-12-10' AS DateTime2), 0, 0);

SET IDENTITY_INSERT DecorativeItems OFF;
";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }


        private static void SeedProductPictures(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT ProductPictures ON;

    INSERT INTO ProductPictures (Id, ImagePath, ProductId, CreatedAt, EntityType)
    VALUES
    -- Images for Product 1 (Sofa Model X)
    (1, N'/images/sample_sofa_1.jpg', 1, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    (2, N'/images/sample_sofa_2.jpg', 1, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    
    -- Images for Product 2 (Krevet Model Y)
    (3, N'/images/sample_bed_1.jpg', 2, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    (4, N'/images/sample_bed_2.jpg', 2, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    
    -- Images for Product 3 (Klub sto Elegance)
    (5, N'/images/sample_table_1.jpg', 3, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    (6, N'/images/sample_table_2.jpg', 3, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    
    -- Images for Product 7 (Sofa L-Shape Comfort)
    (7, N'/images/sample_sofa_L_1.jpg', 7, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    (8, N'/images/sample_sofa_L_2.jpg', 7, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),

    -- Images for Product 8 (Noćni sto Elegant)
    (9, N'/images/table_2.jpg', 8, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    (20, N'/images/table_3.jpg', 8, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product'),
    
    -- Images for Product 9 (Klub sto Rustic)
    (19, N'/images/table_1.jpg', 9, CAST(N'2024-12-15T10:00:00' AS DateTime2), N'Product');

   

    SET IDENTITY_INSERT ProductPictures OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

        private static void SeedDecorativeItemPictures(AppDbContext context)
        {
            var sqlCommand = @"
    SET IDENTITY_INSERT ProductPictures ON;

    INSERT INTO ProductPictures (Id, ImagePath, EntityId, EntityType, DecorativeItemId, CreatedAt)
    VALUES
    -- Images for Vaza Elegance (ID: 1)
    (10, N'/images/decor_vase_1.jpg', 1, N'DecorativeItem', 1, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    (11, N'/images/decor_vase_2.jpg', 1, N'DecorativeItem', 1, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Zidni sat Rustic (ID: 2)
    (12, N'/images/decor_clock_1.jpg', 2, N'DecorativeItem', 2, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    (13, N'/images/decor_clock_2.jpg', 2, N'DecorativeItem', 2, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Svijećnjak Stakleni (ID: 3)
    (14, N'/images/decor_candle_1.jpg', 3, N'DecorativeItem', 3, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Ukrasna figura Mjesec (ID: 4)
    (15, N'/images/decor_moon_1.jpg', 4, N'DecorativeItem', 4, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Zidna dekoracija MetalArt (ID: 5)
    (16, N'/images/decor_wall_1.jpg', 5, N'DecorativeItem', 5, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Jastuk Floral (ID: 6)
    (17, N'/images/decor_pillow_1.jpg', 6, N'DecorativeItem', 6, CAST(N'2024-12-15T10:00:00' AS DateTime2)),
    
    -- Images for Ukrasni pladanj MirrorLux (ID: 7)
    (18, N'/images/decor_tray_1.jpg', 7, N'DecorativeItem', 7, CAST(N'2024-12-15T10:00:00' AS DateTime2));

    SET IDENTITY_INSERT ProductPictures OFF;
    ";

            context.Database.ExecuteSqlRaw(sqlCommand);
        }

    }
}
