import 'package:demo/export.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../features/report/widget/report_screen_appbar.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;
  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: reportScreenAppbar(title),
      body: WebViewWidget(controller: controller),
    );
  }
}
