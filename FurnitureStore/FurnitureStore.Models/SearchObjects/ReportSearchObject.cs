using FurnitureStore.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.SearchObjects
{
    public class ReportSearchObject : BaseSearchObject
    {
        public DateTime? MinGenerationDate { get; set; }
        public DateTime? MaxGenerationDate { get; set; }
        public Month Month { get; set; }
        public ReportType ReportType { get; set; }
        public int? Year { get; set; }
        public string? AdminId { get; set; }
        public string? CustomerId { get; set; }

    }

}
