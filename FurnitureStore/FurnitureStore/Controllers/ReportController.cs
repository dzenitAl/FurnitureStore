using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportController : BaseCRUDController<Models.Report.Report, ReportSearchObject,
        Models.Report.ReportRequest, Models.Report.ReportRequest, long>
    {
        public ReportController(ILogger<BaseController<Models.Report.Report, ReportSearchObject, long>> logger, IReportService service) : base(logger, service)
        {
        }
    }
}
