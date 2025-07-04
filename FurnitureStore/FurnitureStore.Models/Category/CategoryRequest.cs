﻿using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Category
{
    public class CategoryRequest
    {
        public string Name { get; set; }
        public string? Description { get; set; }
        public long? ImageId { get; set; }
        public IFormFile? ImageFile { get; set; }

    }
}
