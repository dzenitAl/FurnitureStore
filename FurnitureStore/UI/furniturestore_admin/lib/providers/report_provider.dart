import 'package:furniturestore_admin/models/report/report.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class ReportProvider extends BaseProvider<ReportModel> {
  ReportProvider() : super("Report");

  @override
  ReportModel fromJson(data) {
    return ReportModel.fromJson(data);
  }
}
