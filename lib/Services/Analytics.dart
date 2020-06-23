import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Analytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Future logEvent({String page}) async {
    await analytics.logEvent(name: page);
  }

  Future appOpen() async {
    await analytics.logAppOpen();
  }

  Future share() async {
    await analytics.logShare(contentType: 'App', itemId: null, method: null);
  }

  Future Uninstalled({String packageName}) async {
    await analytics.logRemoveFromCart(
        itemId: packageName,
        itemName: null,
        itemCategory: null,
        quantity: null);
  }

  Future CheckReplacableApp({String PackageName}) async {
    await analytics.logViewItem(
        itemId: PackageName, itemName: null, itemCategory: null);
  }

  Future Install({String packageName}) async {
    await analytics.logViewSearchResults(searchTerm: packageName);
  }

  Future Hide() async {
    await analytics.logAddPaymentInfo();
  }
}
