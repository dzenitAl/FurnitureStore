﻿using FurnitureStore.Models.GiftCard;
using FurnitureStore.Models.SearchObjects;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Services.Interfaces
{
    public interface IGiftCardService :
       ICRUDService<Models.GiftCard.GiftCard, GiftCardSearchObject, GiftCardInsertRequest, GiftCardUpdateRequest, long>,
       IBaseImageHandlingService<Models.GiftCard.GiftCard, long>
    {
    }
}
