package com.example.food_ai

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraCharacteristics
import android.content.Context

class MainActivity: FlutterActivity() {
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "focalLengthGetter")
        channel.setMethodCallHandler {
            call, result ->
            if (call.method == "getFocalLength") {
                val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
                val camInfo: CameraCharacteristics = cameraManager.getCameraCharacteristics("0")

                val focalLengths = camInfo.get(CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS)
                val sensorWidth = camInfo.get(CameraCharacteristics.SENSOR_INFO_PHYSICAL_SIZE);
                if (focalLengths != null && focalLengths.isNotEmpty() && sensorWidth != null) {
                    val firstFocalLength = focalLengths[0]
                    result.success((36 * firstFocalLength)/sensorWidth.getWidth())
                } else {
                    // Handle the case when focal lengths are not available
                    result.error("Focal lengths not available", null, null)
                }
            }
        }
    }
}
