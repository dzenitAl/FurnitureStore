
using FurnitureStore.Models.Enums;

namespace FurnitureStore.Models.Report
{
    public class Report
    {
        public long Id { get; set; }
        public DateTime GenerationDate { get; set; }
        public Month Month { get; set; }
        public string MonthName { get; set; }
        public int Year { get; set; }
        public string Content { get; set; }
        public string AdminId { get; set; }
        public User.User Admin { get; set; }
    }
}
