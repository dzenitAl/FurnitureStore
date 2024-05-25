
using FurnitureStore.Models.SearchObjects;

namespace FurnitureStore.Services.Interfaces
{
    public interface IReportService : ICRUDService<Models.Report.Report, ReportSearchObject,
        Models.Report.ReportRequest, Models.Report.ReportRequest, long>
    {
    }
}
