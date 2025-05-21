import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocViewerService {
  static const String _privacyPolicyUrl = 'https://raw.githubusercontent.com/cogniwave/cartan/main/docs/privacy_policy.pdf';
  static const String _termsOfServiceUrl = 'https://raw.githubusercontent.com/cogniwave/cartan/main/docs/terms_of_service.pdf';

  static String get _privacyPolicyGoogleViewerUrl => 'https://docs.google.com/viewer?url=${Uri.encodeComponent(_privacyPolicyUrl)}&embedded=true';
  static String get _termsOfServiceGoogleViewerUrl => 'https://docs.google.com/viewer?url=${Uri.encodeComponent(_termsOfServiceUrl)}&embedded=true';

  static void openPrivacyPolicy(BuildContext context, {required String title, Function(Exception)? onError}) {
    _openDocInWebView(context, _privacyPolicyGoogleViewerUrl, title, onError);
  }

  static void openTermsOfService(BuildContext context, {required String title, Function(Exception)? onError}) {
    _openDocInWebView(context, _termsOfServiceGoogleViewerUrl, title, onError);
  }

  static void _openDocInWebView(
      BuildContext context,
      String url,
      String title,
      Function(Exception)? onError,
      ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DocViewerScreen(url: url, title: title, onError: onError),
      ),
    );
  }

  static Future<bool> openDocExternally(String url, Function(Exception)? onError) async {
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

class _DocViewerScreen extends StatefulWidget {
  final String url;
  final String title;
  final Function(Exception)? onError;

  const _DocViewerScreen({
    required this.url,
    required this.title,
    this.onError,
  });

  @override
  _DocViewerScreenState createState() => _DocViewerScreenState();
}

class _DocViewerScreenState extends State<_DocViewerScreen> {
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
        actions: [
          IconButton(
            icon: Icon(AntIcons.exportOutlined),
            onPressed: () {
              DocViewerService.openDocExternally(
                widget.url.contains('docs.google.com')
                    ? widget.url.split('url=')[1].split('&')[0]
                    : widget.url,
                widget.onError,
              );
            },
          ),
        ],
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