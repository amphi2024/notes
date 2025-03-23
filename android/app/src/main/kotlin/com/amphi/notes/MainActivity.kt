package com.amphi.notes

import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    override fun onResume() {
        super.onResume()
        setNavigationBarColor(
            window = window,
            navigationBarColor = navigationBarColor,
            transparentNavigationBar = transparentNavigationBar
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= 29) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
            )
        }
    }

    private var methodChannel: MethodChannel? = null
    private var storagePath: String? = null
    private var navigationBarColor: Int = 0
    private var transparentNavigationBar: Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)
        storagePath = filesDir.path
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            val window = this@MainActivity.window
            when (call.method) {
                "set_navigation_bar_color" -> {
                    val color = call.argument<Long>("color")
                    val transparentNav = call.argument<Boolean>("transparent_navigationBar")

                    if (color != null && transparentNav != null) {
                        this.transparentNavigationBar = transparentNav
                        navigationBarColor = color.toInt()

                        setNavigationBarColor(
                            window = window,
                            navigationBarColor = navigationBarColor,
                            transparentNavigationBar = this.transparentNavigationBar
                        )

                    }

                }

                "get_system_version" -> {
                    result.success(Build.VERSION.SDK_INT)
                }

                "configure_needs_bottom_padding" -> {
                    val navigationMode = Settings.Secure.getInt(contentResolver, "navigation_mode")
                    result.success(Build.VERSION.SDK_INT >= 35 && navigationMode != 2)
                }

                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val CHANNEL = "notes_method_channel"
    }
}
