﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class SubcategorySearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public long? CategoryId { get; set; }
    }

}
