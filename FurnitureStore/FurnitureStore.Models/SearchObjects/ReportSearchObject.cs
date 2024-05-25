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
        public string MonthName { get; set; }
        public int Year { get; set; }
        public string AdminId { get; set; }
    }

}
