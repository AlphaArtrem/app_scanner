package app.replace.phone.cleaner;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.app.Activity;
import android.widget.TextView;
import android.view.View;
import android.net.Uri;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.alphaartrem.appscanner/deleteApp";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("deleteApp")) {
                                String Package = call.argument("package");
                                int res = deleteApp(Package);

                                if (res == 0) {
                                    result.success(res);
                                } else {
                                    result.error("Error : ", "Couldn't uninstall app.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private int deleteApp(String Package) {
        try {
            Uri packageUri = Uri.parse("package:" + Package);
            Intent uninstallIntent = new Intent(Intent.ACTION_DELETE, packageUri);
            startActivity(uninstallIntent);
            return 0;

        }catch (Exception e){
            return 1;
        }
    }
}