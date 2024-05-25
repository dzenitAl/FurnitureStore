using AutoMapper;
using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Database;
using FurnitureStore.Services.Interfaces;

namespace FurnitureStore.Services.Services
{
    public class ReportService : BaseCRUDService<Models.Report.Report, Database.Report, ReportSearchObject,
        Models.Report.ReportRequest, Models.Report.ReportRequest,long>, IReportService
    {
        public ReportService(AppDbContext context, IMapper mapper) : base(context, mapper) { }
    }
}
