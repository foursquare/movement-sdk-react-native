package com.foursquare.movement.react

import android.content.Intent
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.foursquare.movement.MovementSdk
import com.foursquare.movement.NotificationTester
import com.foursquare.movement.debugging.SdkDebugActivity

@Suppress("unused")
class RNMovementSdkModule(private val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "RNMovementSdk"

    @ReactMethod
    fun getInstallId(promise: Promise) = promise.resolve(MovementSdk.getInstallId())

    @ReactMethod
    fun start() = MovementSdk.start(reactContext)

    @ReactMethod
    fun stop() = MovementSdk.stop(reactContext)

    @ReactMethod
    fun getCurrentLocation(promise: Promise) {
        Thread {
            val currentLocationResult = MovementSdk.get().getCurrentLocation()
            if (currentLocationResult.isOk) {
                promise.resolve(Utils.currentLocationJson(currentLocationResult.result))
            } else {
                promise.reject("E_GET_CURRENT_LOCATION", currentLocationResult.err)
            }
        }.start()
    }

    @ReactMethod
    fun fireTestVisit(latitude: Double, longitude: Double) =
        NotificationTester.sendTestVisitArrivalAtLocation(
            reactContext,
            latitude,
            longitude,
            false
        )

    @ReactMethod
    fun showDebugScreen() {
        val intent = Intent(reactContext, SdkDebugActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        reactContext.startActivity(intent)
    }

    @ReactMethod
    fun isEnabled(promise: Promise) = promise.resolve(MovementSdk.isEnabled())
}
