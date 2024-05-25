using FurnitureStore.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Interfaces
{
    public interface IGiftCardService : ICRUDService<Models.GiftCard.GiftCard, Models.SearchObjects.GiftCardSearchObject,
        Models.GiftCard.GiftCardInsertRequest, Models.GiftCard.GiftCardUpdateRequest, long>
    {
    }
}
