import 'package:url_launcher/url_launcher.dart';

class ExternalLinkLauncher {
  const ExternalLinkLauncher();

  Future<bool> open(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null || !uri.hasScheme) {
      return false;
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
