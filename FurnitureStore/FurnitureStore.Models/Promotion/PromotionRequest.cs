﻿using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Promotion
{
    public class PromotionRequest
    {
        public string Heading { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public List<long> ProductIds { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public long? ImageId { get; set; }
        public IFormFile? ImageFile { get; set; }

    }


}
