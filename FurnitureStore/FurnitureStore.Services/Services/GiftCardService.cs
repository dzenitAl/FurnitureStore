using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class GiftCardService : BaseCRUDService<Models.GiftCard.GiftCard, Database.GiftCard, 
        GiftCardSearchObject, Models.GiftCard.GiftCardInsertRequest, Models.GiftCard.GiftCardUpdateRequest,long>, IGiftCardService
    {
        public GiftCardService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
