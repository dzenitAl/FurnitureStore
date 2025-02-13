using AutoMapper;
using FurnitureStoreDodatni.Dtos.Notification;
using FurnitureStoreDodatni.Dtos.User;

namespace FurnitureStoreDodatni.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Notification, Notification>();
            CreateMap<Database.User, UserResponse>();
        }
    }
}
