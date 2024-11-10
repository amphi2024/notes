package com.amphi.notes

import android.graphics.Color
import android.os.Build
import android.view.View
import android.view.Window
import android.view.WindowInsetsController
import android.view.WindowManager

fun setNavigationBarColor(window: Window, navigationBarColor: Int, iosLikeUi: Boolean) {
    if(iosLikeUi) {
        window.setFlags(
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        )
    }
    else {
        window.clearFlags(
            WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
        )
        if (Build.VERSION.SDK_INT >= 30) {

            window.setDecorFitsSystemWindows(false)
            val controller = window.insetsController
            val parsedColor = Color.valueOf(navigationBarColor)
            if(parsedColor.red() + parsedColor.blue() + parsedColor.green() >= 1.5) {
                controller?.setSystemBarsAppearance(
                    WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS,
                    WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
                )
            }
            else {
                controller?.setSystemBarsAppearance(
                    0,
                    WindowInsetsController.APPEARANCE_LIGHT_NAVIGATION_BARS
                )
            }

            window.navigationBarColor = navigationBarColor
        }
        else if(Build.VERSION.SDK_INT >= 26) {
            val parsedColor = Color.valueOf(navigationBarColor)
            if(parsedColor.red() + parsedColor.blue() + parsedColor.green() >= 1.5) {
                @Suppress("DEPRECATION")
                window.decorView.systemUiVisibility = window.decorView.systemUiVisibility or
                        View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
            }
            else {
                @Suppress("DEPRECATION")
                window.decorView.systemUiVisibility = window.decorView.systemUiVisibility and
                        View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR.inv()
            }
            window.navigationBarColor = navigationBarColor
        }
    }

}