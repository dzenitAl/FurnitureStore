using FurnitureStore.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FurnitureStore.Models.Report
{
    public class ReportRequest
    {
        public DateTime GenerationDate { get; set; }
        public Month Month { get; set; }
        public ReportType ReportType { get; set; }
        public int Year { get; set; }
        public string? Content { get; set; }
        public string AdminId { get; set; }
        public string CustomerId { get; set; }
        public string? CreatedById { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public string? LastModifiedBy { get; set; }
        public DateTime? LastModified { get; set; }
        public DateTime? DeletedAt { get; set; }
    }
}
