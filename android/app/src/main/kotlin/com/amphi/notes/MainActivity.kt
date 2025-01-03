package com.amphi.notes

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    override fun onResume() {
        super.onResume()
        setNavigationBarColor(
            window = window,
            navigationBarColor = navigationBarColor,
            iosLikeUi = iosLikeUi
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        )
    }

    private var methodChannel: MethodChannel? = null
    private var storagePath : String? = null
    private var navigationBarColor : Int = 0
    private var iosLikeUi : Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)
        storagePath = filesDir.path
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            val window = this@MainActivity.window
            when (call.method) {
                "set_navigation_bar_color" -> {
                    val color = call.argument<Long>("color")
                    val iosUi = call.argument<Boolean>("ios_like_ui")

                    if(color != null && iosUi != null) {
                        iosLikeUi = iosUi
                        navigationBarColor = color.toInt()

                     setNavigationBarColor(
                         window = window,
                         navigationBarColor = navigationBarColor,
                         iosLikeUi = iosLikeUi
                     )

                    }

                }
                "get_system_version" -> {
                    result.success(Build.VERSION.SDK_INT)
                }
                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val CHANNEL = "notes_method_channel"
    }
}
