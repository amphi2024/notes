package com.amphi.notes

import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.content.res.Configuration.UI_MODE_NIGHT_MASK
import android.content.res.Configuration.UI_MODE_NIGHT_YES
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.view.WindowManager
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        val currentNightMode = newConfig.uiMode and UI_MODE_NIGHT_MASK
        when (currentNightMode) {
            UI_MODE_NIGHT_YES -> {
                if(methodChannel != null) {
                    methodChannel!!.invokeMethod("dark_theme", "")
                }
            }
            else -> {
                if(methodChannel != null) {
                    methodChannel!!.invokeMethod("light_theme", "")
                }
            }
        }
    }

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
                "select_image" -> {
                    val intent = Intent(Intent.ACTION_GET_CONTENT)
                    intent.setType("image/*")
                    startActivityForResult(intent, REQUEST_CODE_IMAGE)
                }

                "select_video" -> {
                    val intent = Intent(Intent.ACTION_GET_CONTENT)
                    intent.setType("video/*")
                    startActivityForResult(intent, REQUEST_CODE_VIDEO)
                }

                "get_storage_path" -> {
                    result.success(storagePath)
                }

                "rotate_screen" -> {
                    if(resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
                        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
                        if (Build.VERSION.SDK_INT >= 30) {
                            window.setDecorFitsSystemWindows(true)
                            window.insetsController?.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                        }
                        else {
                            @Suppress("DEPRECATION")
                            window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                        }
                    }
                    else {
                        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                        if (Build.VERSION.SDK_INT >= 30) {
                            window.setDecorFitsSystemWindows(false)
                            window.insetsController?.let { controller ->
                                controller.hide(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                                controller.systemBarsBehavior = WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
                            }
                        }
                        else {
                            @Suppress("DEPRECATION")
                            window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                        }
                    }
                }

                "set_portrait" -> {
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
                    if (Build.VERSION.SDK_INT >= 30) {
                        window.setDecorFitsSystemWindows(true)
                        window.insetsController?.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                    }
                    else {
                        @Suppress("DEPRECATION")
                        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                    }

                }
                "set_landscape" -> {
                    requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    //window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                    if (Build.VERSION.SDK_INT >= 30) {
                        window.setDecorFitsSystemWindows(false)
                        window.insetsController?.let { controller ->
                            controller.hide(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                            controller.systemBarsBehavior = WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
                        }
                    }
                    else {
                        @Suppress("DEPRECATION")
                        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
                    }

                }
                "show_toast" -> {
                    val message = call.argument<String>("message")
                    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
                }
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_IMAGE && resultCode == RESULT_OK) {
            try {
                if(data != null) {
                    val uri = data.data
                    if (uri != null) {
                        methodChannel!!.invokeMethod("on_image_selected", getFilePathFromUri(uri, MediaStore.Images.Media.DATA))
                    }
                    else {
                        methodChannel!!.invokeMethod("fail_image", "")
                    }
                }

            } catch (e: Exception) {
                methodChannel!!.invokeMethod("fail_image", "")
                e.printStackTrace()
            }
        }
        else if(requestCode == REQUEST_CODE_VIDEO && resultCode == RESULT_OK) {
            try {
                if(data != null) {
                    val uri = data.data
                    if (uri != null) {
                        methodChannel!!.invokeMethod("on_video_selected", getFilePathFromUri(uri, MediaStore.Video.Media.DATA))
                    }
                    else {
                        methodChannel!!.invokeMethod("fail_video", "")
                    }
                }
            } catch (e: Exception) {
                methodChannel!!.invokeMethod("fail_video", "")
                e.printStackTrace()
            }
        }
    }

    private fun getFilePathFromUri(uri: Uri, contentType: String): String? {
        var filePath: String? = null
        if (uri.scheme == "content") {
            val projection = arrayOf(contentType)
            contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
                val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
                if (cursor.moveToFirst()) {
                    filePath = cursor.getString(columnIndex)
                }
            }
        } else if (uri.scheme == "file") {
            filePath = uri.path
        }
        return filePath
    }

    companion object {
        private const val CHANNEL = "notes_method_channel"

        const val REQUEST_CODE_IMAGE = 0
        const val REQUEST_CODE_VIDEO = 1
    }
}
