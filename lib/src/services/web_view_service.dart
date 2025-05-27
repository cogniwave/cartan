import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebViewService {
  static String get _privacyPolicyUrl => dotenv.env['PRIVACY_POLICY_URL']!;
  static String get _termsOfServiceUrl => dotenv.env['TERMS_OF_SERVICE_URL']!;

  static void openPrivacyPolicy(BuildContext context, {required String title, Function(Exception)? onError}) {
    _openInWebView(context, _privacyPolicyUrl, title, onError);
  }

  static void openTermsOfService(BuildContext context, {required String title, Function(Exception)? onError}) {
    _openInWebView(context, _termsOfServiceUrl, title, onError);
  }

  static void _openInWebView(
      BuildContext context,
      String url,
      String title,
      Function(Exception)? onError,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _WebViewScreen(url: url, title: title, onError: onError),
      ),
    );
  }

  static Future<bool> openUrlExternally(String url, Function(Exception)? onError) async {
    try {
      final Uri uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (onError != null) {
        onError(e is Exception ? e : Exception(e.toString()));
      }
      return false;
    }
  }
}

class _WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final Function(Exception)? onError;

  const _WebViewScreen({
    required this.url,
    required this.title,
    this.onError,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<_WebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            if (widget.onError != null) {
              widget.onError!(Exception(error.description));
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}