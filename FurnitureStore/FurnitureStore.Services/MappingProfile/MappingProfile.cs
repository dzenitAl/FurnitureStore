using AutoMapper;
using FurnitureStore.Models.Account;
using FurnitureStore.Models.Category;
using FurnitureStore.Models.City;
using FurnitureStore.Models.CustomFurnitureReservation;
using FurnitureStore.Models.GiftCard;
using FurnitureStore.Models.Notification;
using FurnitureStore.Models.Order;
using FurnitureStore.Models.OrderItem;
using FurnitureStore.Models.Payment;
using FurnitureStore.Models.Product;
using FurnitureStore.Models.ProductPicture;
using FurnitureStore.Models.ProductReservationItem;
using FurnitureStore.Models.Promotion;
using FurnitureStore.Models.Report;
using FurnitureStore.Models.Subcategory;
using FurnitureStore.Models.WishList;


namespace FurnitureStore.Services.MappingProfile
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Payment, Models.Payment.Payment>();
            CreateMap<PaymentRequest, Database.Payment>();
            CreateMap<Database.CustomFurnitureReservation, CustomFurnitureReservation>();
            CreateMap<CustomeFurnitureReservationInsertRequest, Database.CustomFurnitureReservation>();
            CreateMap<CustomeFurnitureReservationUpdateRequest, Database.CustomFurnitureReservation>();
            CreateMap<Database.Order, Order>();
            CreateMap<OrderInsertRequest, Database.Order>();
            CreateMap<OrderUpdateRequest, Database.Order>();
            CreateMap<Database.OrderItem, OrderItem>();
            CreateMap<OrderItemRequest, Database.OrderItem>();
            CreateMap<Database.Notification, Notification>();
            CreateMap<NotificationInsertRequest, Database.Notification>();
            CreateMap<NotificationUpdateRequest, Database.Notification>();
            CreateMap<Database.GiftCard, GiftCard>();
            CreateMap<GiftCardInsertRequest, Database.GiftCard>();
            CreateMap<GiftCardUpdateRequest, Database.GiftCard>();
            CreateMap<Database.City, City>();
            CreateMap<Database.Subcategory, Subcategory>();
            CreateMap<SubcategoryRequest, Database.Subcategory>();
            CreateMap<Database.Category, Category>();
            CreateMap<CategoryRequest, Database.Category>();
            CreateMap<Database.City, City>();
            CreateMap<CityRequest, Database.City>();
            CreateMap<Database.Product, Product>();
            CreateMap<ProductInsertRequest, Database.Product>();
            CreateMap<ProductUpdateRequest, Database.Product>();
            CreateMap<Database.ProductPicture, ProductPicture>();
            CreateMap<ProductPictureInsertRequest, Database.ProductPicture>();
            CreateMap<ProductPictureUpdateRequest, Database.ProductPicture>();
            CreateMap<Database.ProductReservation, Models.ProductReservation.ProductReservation>();
            CreateMap<Models.ProductReservation.ProductReservation, Database.ProductReservation>();
            CreateMap<Models.ProductReservation.ProductReservationUpdateRequest, Database.ProductReservation>();
            CreateMap<Database.ProductReservation, Models.ProductReservation.ProductReservationUpdateRequest>();
            CreateMap<Database.ProductReservationItem, ProductReservationItem>();
            CreateMap<ProductReservationItem, Database.ProductReservationItem>();
            CreateMap<Database.Report, Report>();
            CreateMap<ReportRequest, Database.Report>();
            CreateMap<Database.Promotion, Promotion>();
            CreateMap<PromotionRequest, Database.Promotion>();
            CreateMap<Database.WishList, WishList>();
            CreateMap<WishListRequest, Database.WishList>();
            CreateMap<Database.User, UserResponse>();

        }
    }
}
