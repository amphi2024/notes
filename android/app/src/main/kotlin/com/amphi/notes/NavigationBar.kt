package com.amphi.notes

import android.os.Build
import android.view.View
import android.view.Window
import android.view.WindowInsetsController
import android.view.WindowManager

fun setNavigationBarColor(window: Window, navigationBarColor: Int, iosLikeUi: Boolean) {
    if(iosLikeUi) {
        if(Build.VERSION.SDK_INT >= 30) {
            val controller = window.insetsController
            controller?.setSystemBarsAppearance(0, WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS)
            window.setDecorFitsSystemWindows(false)
            window.navigationBarColor = android.graphics.Color.TRANSPARENT
            window.statusBarColor = android.graphics.Color.TRANSPARENT
        }
        else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = (
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    )
            @Suppress("DEPRECATION")
            window.navigationBarColor = android.graphics.Color.TRANSPARENT
            @Suppress("DEPRECATION")
            window.statusBarColor = android.graphics.Color.TRANSPARENT
        }
    }
    else {
        window.clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        if(Build.VERSION.SDK_INT >= 30) {
            val controller = window.insetsController
            window.setDecorFitsSystemWindows(true)
            window.navigationBarColor = navigationBarColor
            window.statusBarColor = navigationBarColor
            controller?.setSystemBarsAppearance(
                WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS,
                WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
            )
        }
        else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
            @Suppress("DEPRECATION")
            window.navigationBarColor = navigationBarColor
            @Suppress("DEPRECATION")
            window.statusBarColor = navigationBarColor
        }
    }

}