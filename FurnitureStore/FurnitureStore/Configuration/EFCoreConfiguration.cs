using FurnitureStore.Models.Enums;
using FurnitureStore.Services.Database;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

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

                //if (!context.Payments.Any())
                //{
                //    SeedPayments(context);
                //}


                //if (!context.ProductPictures.Any())
                //{
                //    SeedProductPictures(context);
                //}


            }

        }


        private static void SeedData<T>(AppDbContext context, string tableName, List<T> data) where T : class
        {
            using (var transaction = context.Database.BeginTransaction())
            {
                try
                {
                    var dbSet = context.Set<T>();
                    var existingData = dbSet.AsNoTracking().ToList();
                    var newData = data.Where(d => !existingData.Contains(d)).ToList();

                    if (newData.Any())
                    {
                        context.Database.ExecuteSqlRaw($"SET IDENTITY_INSERT {tableName} ON;");

                        dbSet.AddRange(newData);
                        context.SaveChanges();

                        context.Database.ExecuteSqlRaw($"SET IDENTITY_INSERT {tableName} OFF;");
                    }

                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        private static void SeedCities(AppDbContext context)
        {
            var cities = new List<City>
    {
        new City { Id = 1, Name = "Mostar", CreatedAt = DateTime.Parse("2024-12-12") },
        new City { Id = 2, Name = "Visoko", CreatedAt = DateTime.Parse("2024-12-12") },
        new City { Id = 3, Name = "Sarajevo", CreatedAt = DateTime.Parse("2024-12-12") },
        new City { Id = 3, Name = "Zenica", CreatedAt = DateTime.Parse("2024-12-12") }
    };

            SeedData(context, "Cities", cities);
        }

        private static void SeedRoles(AppDbContext context)
        {
            var roles = new List<Role>
    {
        new Role { Id = "admin", Name = Roles.Admin },
        new Role { Id = "customer", Name = Roles.Customer }
    };

            SeedData(context, "Roles", roles);
        }

        private static void SeedUsers(AppDbContext context, IServiceScope serviceScope)
        {
            var userManager = serviceScope.ServiceProvider.GetRequiredService<UserManager<User>>();

            if (!context.Users.Any(u => u.Username == "admin"))
            {
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
                    CityId = 1,
                    CreatedAt = DateTime.Parse("2024-12-12"),
                    CreatedById = null,
                    EmailConfirmed = true
                };

                var result = userManager.CreateAsync(admin, "Admin123!").Result;
                if (result.Succeeded)
                {
                    userManager.AddToRoleAsync(admin, Roles.Admin).Wait();
                }
            }

            if (!context.Users.Any(u => u.Username == "customer"))
            {
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
                    CityId = 1,
                    CreatedAt = DateTime.Parse("2024-12-12"),
                    CreatedById = null,
                    EmailConfirmed = true
                };

                var result = userManager.CreateAsync(customer, "Customer123!").Result;
                if (result.Succeeded)
                {
                    userManager.AddToRoleAsync(customer, Roles.Customer).Wait();
                }
            }
        }

        private static void SeedCategories(AppDbContext context)
        {
            var categories = new List<Category>
    {
        new Category { Id = 1, Name = "Dnevni boravak", Description = "Kategorija za namještaj namijenjen dnevnim boravcima", CreatedAt = DateTime.Parse("2024-12-10") },
        new Category { Id = 2, Name = "Spavaća soba", Description = "Kategorija za namještaj namijenjen spavaćim sobama", CreatedAt = DateTime.Parse("2024-12-10") },
        new Category { Id = 3, Name = "Kancelarijski namještaj", Description = "Kategorija za kancelarijski namještaj", CreatedAt = DateTime.Parse("2024-12-10") }
    };

            SeedData(context, "Categories", categories);
        }

        private static void SeedSubcategories(AppDbContext context)
        {
            var subcategories = new List<Subcategory>
    {
        new Subcategory { Id = 1, Name = "Sofe", CategoryId = 1, CreatedAt = DateTime.Parse("2024-12-10") },
        new Subcategory { Id = 2, Name = "Klub stolovi", CategoryId = 1, CreatedAt = DateTime.Parse("2024-12-10") },
        new Subcategory { Id = 3, Name = "Kreveti", CategoryId = 2, CreatedAt = DateTime.Parse("2024-12-10") },
        new Subcategory { Id = 4, Name = "Ormari", CategoryId = 2, CreatedAt = DateTime.Parse("2024-12-10") },
        new Subcategory { Id = 5, Name = "Radni stolovi", CategoryId = 3, CreatedAt = DateTime.Parse("2024-12-10") },
        new Subcategory { Id = 6, Name = "Kancelarijske stolice", CategoryId = 3, CreatedAt = DateTime.Parse("2024-12-10") }
    };

            SeedData(context, "Subcategories", subcategories);
        }

        private static void SeedProducts(AppDbContext context)
        {
            if (!context.Products.Any())
            {
                var subcategories = context.Subcategories.ToList();

                var products = new List<Product>
        {
            new Product
            {
                Name = "Sofa Model X",
                Description = "Elegantna sofa za dnevni boravak.",
                Price = 900,
                Dimensions = "200x90x80 cm",
                IsAvailableInStore = true,
                IsAvailableOnline = true,
                SubcategoryId = subcategories.FirstOrDefault(s => s.Name == "Sofe")?.Id ?? 1,
                CreatedAt = DateTime.UtcNow,
                Barcode = "123456789012",
            },
            new Product
            {
                Name = "Krevet Model Y",
                Description = "Udoban krevet za spavaću sobu.",
                Price = 799.99,
                Dimensions = "180x200 cm",
                IsAvailableInStore = true,
                IsAvailableOnline = true,
                SubcategoryId = subcategories.FirstOrDefault(s => s.Name == "Kreveti")?.Id ?? 1,
                CreatedAt = DateTime.UtcNow,
                Barcode = "234567890123",
            }
        };

                context.Products.AddRange(products);
                context.SaveChanges();
            }
        }

        private static void SeedProductReservations(AppDbContext context)
        {
            if (!context.ProductReservations.Any())
            {
                var users = context.Users.ToList();

                var reservations = new List<ProductReservation>
        {
            new ProductReservation
            {
                ReservationDate = DateTime.UtcNow.AddDays(2),
                Notes = "Rezervacija za test proizvod",
                CustomerId = users.FirstOrDefault(u => u.Username == "customer")?.Id ?? users.First().Id,
                CreatedAt = DateTime.UtcNow,
                IsApproved = false
            }
        };

                context.ProductReservations.AddRange(reservations);
                context.SaveChanges();
            }
        }
        private static void SeedProductReservationItems(AppDbContext context)
        {
            if (!context.ProductReservationItems.Any())
            {
                var products = context.Products.ToList();
                var reservations = context.ProductReservations.ToList();

                var reservationItems = new List<ProductReservationItem>
        {
            new ProductReservationItem
            {
                Quantity = 2,
                ProductReservationId = reservations.First().Id,
                ProductId = products.First().Id,
                CreatedAt = DateTime.UtcNow
            }
        };

                context.ProductReservationItems.AddRange(reservationItems);
                context.SaveChanges();
            }
        }


        private static void SeedPromotions(AppDbContext context)
        {
            if (!context.Promotions.Any())
            {
                var admin = context.Users.FirstOrDefault(u => u.Username == "admin");

                if (admin == null)
                {
                    var adminUser = new User
                    {
                        Id = "ff697def-9c3d-4b5a-84e2-e0ff755e9bc0",
                        Username = "admin",
                        Email = "admin@example.com",
                        FirstName = "Admin",
                        LastName = "User",
                        BirthDate = DateTime.Parse("1999-12-12"),
                        Gender = Gender.Male,
                        PhoneNumber = "062245878",
                        CityId = 1,
                        CreatedAt = DateTime.Parse("2024-12-12"),
                        CreatedById = null,
                        EmailConfirmed = true
                    };
                    context.Users.Add(adminUser);
                    context.SaveChanges();
                    admin = adminUser;
                }

                var promotion = new Promotion
                {
                    Heading = "Promocija zimske rasprodaje",
                    Content = "Ne propustite fantastične popuste do 50% na sve proizvode!",
                    AdminId = admin.Id,
                    CreatedAt = DateTime.UtcNow,
                    CreatedById = null,
                    LastModified = DateTime.UtcNow,
                    LastModifiedBy = null
                };

                context.Promotions.Add(promotion);
                context.SaveChanges();
            }
        }


        private static void SeedGiftCards(AppDbContext context)
        {
            if (!context.GiftCards.Any())
            {
                var giftCard = new GiftCard
                {
                    Name = "Poklon kartica 50€",
                    CardNumber = "1234-5678-9012-3456",
                    Amount = 50,
                    ExpiryDate = DateTime.UtcNow.AddYears(1),
                    IsActivated = true,
                    CreatedAt = DateTime.UtcNow,
                    CreatedById = null,
                    LastModified = DateTime.UtcNow,
                    LastModifiedBy = null
                };

                context.GiftCards.Add(giftCard);
                context.SaveChanges();
            }
        }

        private static void SeedCustomFurnitureReservations(AppDbContext context)
        {
            if (!context.CustomFurnitureReservations.Any())
            {
                var user = context.Users.FirstOrDefault(u => u.Username == "customer");

                if (user != null)
                {
                    var customFurnitureReservation = new CustomFurnitureReservation
                    {
                        Note = "Rezervacija za custom namještaj",
                        ReservationDate = DateTime.UtcNow.AddMonths(1),
                        ReservationStatus = true,
                        UserId = user.Id,
                        CreatedAt = DateTime.UtcNow,
                        CreatedById = null,
                        LastModified = DateTime.UtcNow,
                        LastModifiedBy = null
                    };

                    context.CustomFurnitureReservations.Add(customFurnitureReservation);
                    context.SaveChanges();
                }
                else
                {
                    Console.WriteLine("Nema korisnika sa username 'customer'. Kreirajte korisnika prije dodavanja rezervacija.");
                }
            }
        }
        private static void SeedNotifications(AppDbContext context)
        {
            if (!context.Notifications.Any())
            {
                var admin = context.Users.FirstOrDefault(u => u.Username == "admin");

                if (admin != null)
                {
                    var notification = new Notification
                    {
                        Heading = "Nova promocija",
                        Content = "Pregledajte novu promociju zimske rasprodaje na našem sajtu!",
                        AdminId = admin.Id,
                        CreatedAt = DateTime.UtcNow,
                        CreatedById = null,
                        LastModified = DateTime.UtcNow,
                        LastModifiedBy = null
                    };

                    context.Notifications.Add(notification);
                    context.SaveChanges();
                }
                else
                {
                    Console.WriteLine("Nema admin korisnika u bazi. Kreirajte admina prije dodavanja notifikacija.");
                }
            }
        }


        private static void SeedOrders(AppDbContext context)
        {
            if (!context.Orders.Any())
            {
                var users = context.Users.ToList();

                var orders = new List<Order>
        {
            new Order
            {
                OrderDate = DateTime.UtcNow.AddDays(-1),
                Delivery = Delivery.InStorePickup,
                TotalPrice = 400,
                CustomerId = users.FirstOrDefault(u => u.Username == "customer")?.Id ?? users.First().Id,
                CreatedAt = DateTime.UtcNow,
                IsApproved = true
            },
            new Order
            {
                OrderDate = DateTime.UtcNow.AddDays(3),
                Delivery = Delivery.InStorePickup,
                TotalPrice = 250,
                CustomerId = users.FirstOrDefault(u => u.Username == "customer")?.Id ?? users.First().Id,
                CreatedAt = DateTime.UtcNow,
                IsApproved = false
            }
        };

                context.Orders.AddRange(orders);
                context.SaveChanges();
            }
        }


        private static void SeedOrderItems(AppDbContext context)
        {
            if (!context.OrderItems.Any())
            {
                var products = context.Products.ToList();
                var orders = context.Orders.ToList();

                var orderItems = new List<OrderItem>
        {
            new OrderItem
            {
                Quantity = 1,
                OrderId = orders.First().Id,
                ProductId = products.First().Id,
                CreatedAt = DateTime.UtcNow
            },
            new OrderItem
            {
                Quantity = 2,
                OrderId = orders.First().Id,
                ProductId = products.Skip(1).First().Id,
                CreatedAt = DateTime.UtcNow
            }
        };

                context.OrderItems.AddRange(orderItems);
                context.SaveChanges();
            }
        }

        private static void SeedWishLists(AppDbContext context)
        {
            if (!context.WishLists.Any())
            {
                var users = context.Users.ToList();

                var wishLists = new List<WishList>
        {
            new WishList
            {
                DateCreated = DateTime.UtcNow,
                CustomerId = users.FirstOrDefault(u => u.Username == "customer")?.Id ?? users.First().Id,
                CreatedAt = DateTime.UtcNow
            }
        };

                context.WishLists.AddRange(wishLists);
                context.SaveChanges();
            }
        }

        private static void SeedReports(AppDbContext context)
        {
            if (!context.Reports.Any())
            {
                var admins = context.Users.Where(u => u.Username == "admin").ToList(); 
                var customers = context.Users.Where(u => u.Username == "customer").ToList(); 

                var reports = new List<Report>
        {
            new Report
            {
                GenerationDate = DateTime.UtcNow.AddMonths(-1),
                Content = "Monthly sales report for the previous month.",
                AdminId = admins.FirstOrDefault()?.Id ?? admins.First().Id, 
                CustomerId = customers.FirstOrDefault()?.Id ?? customers.First().Id,  
                Month = Month.April,
                Year = DateTime.UtcNow.AddMonths(-1).Year,
                CreatedAt = DateTime.UtcNow,
                CreatedById = admins.FirstOrDefault()?.Id ?? admins.First().Id,  
                ReportType = ReportType.Monthly,
                LastModified = DateTime.UtcNow,
                LastModifiedBy = admins.FirstOrDefault()?.Id ?? admins.First().Id 
            },
             new Report
            {
                GenerationDate = DateTime.UtcNow.AddMonths(-1), 
                Content = "Year-end performance report for the last year.",
                AdminId = admins.FirstOrDefault()?.Id ?? admins.First().Id,  
                CustomerId = customers.FirstOrDefault()?.Id ?? customers.First().Id, 
                Month = Month.June,
                Year = DateTime.UtcNow.AddMonths(-1).Year,
                CreatedAt = DateTime.UtcNow.AddMonths(-1),
                CreatedById = admins.FirstOrDefault()?.Id ?? admins.First().Id,  
                ReportType = ReportType.Yearly, 
                LastModified = DateTime.UtcNow.AddMonths(-1),
                LastModifiedBy = admins.FirstOrDefault()?.Id ?? admins.First().Id  
            }

        };

                context.Reports.AddRange(reports);
                context.SaveChanges();
            }
        }

    }
}
