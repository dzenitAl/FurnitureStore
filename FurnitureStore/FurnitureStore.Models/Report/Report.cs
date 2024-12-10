
using FurnitureStore.Models.Account;
using FurnitureStore.Models.Enums;

namespace FurnitureStore.Models.Report
{
    public class Report
    {
        public long Id { get; set; }
        public DateTime GenerationDate { get; set; }
        public Month Month { get; set; }
        public ReportType ReportType { get; set; }
        public int Year { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public UserResponse Admin { get; set; }
        public string CustomerId { get; set; }
        public UserResponse Customer { get; set; }
    }
}
