package com.jayfinava.flutteredgedetection

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.jayfinava.flutteredgedetection.scan.ScanActivity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import android.net.Uri

class EdgeDetectionHandler : MethodCallHandler, PluginRegistry.ActivityResultListener {
    private var activityPluginBinding: ActivityPluginBinding? = null
    private var result: Result? = null
    private var methodCall: MethodCall? = null

    companion object {
        const val INITIAL_BUNDLE = "initial_bundle"
        const val FROM_GALLERY = "from_gallery"
        const val SAVE_TO = "save_to"
        const val CAN_USE_GALLERY = "can_use_gallery"
        const val SCAN_TITLE = "scan_title"
        const val CROP_TITLE = "crop_title"
        const val CROP_BLACK_WHITE_TITLE = "crop_black_white_title"
        const val CROP_RESET_TITLE = "crop_reset_title"
        const val REQUEST_CODE = 1001
        const val ERROR_CODE = 1002
    }

    fun setActivityPluginBinding(activityPluginBinding: ActivityPluginBinding?) {
        this.activityPluginBinding?.removeActivityResultListener(this)
        this.activityPluginBinding = activityPluginBinding
        activityPluginBinding?.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            getActivity() == null -> {
                result.error(
                    "no_activity",
                    "flutter_edge_detection plugin requires a foreground activity.",
                    null
                )
                return
            }
            call.method == "edge_detect" -> {
                openCameraActivity(call, result)
            }
            call.method == "edge_detect_gallery" -> {
                openGalleryActivity(call, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getActivity(): Activity? {
        return activityPluginBinding?.activity
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    // Check if this is from gallery selection
                    if (data?.data != null && methodCall?.method == "edge_detect_gallery") {
                        // Launch ScanActivity with the selected image
                        val scanIntent = Intent(getActivity()?.applicationContext, com.jayfinava.flutteredgedetection.scan.ScanActivity::class.java)
                        val bundle = Bundle().apply {
                            putString(SAVE_TO, methodCall?.argument<String>(SAVE_TO))
                            putString(CROP_TITLE, methodCall?.argument<String>(CROP_TITLE))
                            putString(CROP_BLACK_WHITE_TITLE, methodCall?.argument<String>(CROP_BLACK_WHITE_TITLE))
                            putString(CROP_RESET_TITLE, methodCall?.argument<String>(CROP_RESET_TITLE))
                            putBoolean(FROM_GALLERY, true)
                            putParcelable("SELECTED_IMAGE_URI", data.data)
                        }
                        scanIntent.putExtra(INITIAL_BUNDLE, bundle)
                        getActivity()?.startActivityForResult(scanIntent, REQUEST_CODE)
                        return true
                    } else {
                        finishWithSuccess(true)
                    }
                }
                Activity.RESULT_CANCELED -> {
                    finishWithSuccess(false)
                }
                ERROR_CODE -> {
                    finishWithError(ERROR_CODE.toString(), data?.getStringExtra("RESULT") ?: "ERROR")
                }
            }
            return true
        }
        return false
    }

    private fun openCameraActivity(call: MethodCall, result: Result) {
        if (!setPendingMethodCallAndResult(call, result)) {
            finishWithAlreadyActiveError()
            return
        }

        val initialIntent = Intent(getActivity()?.applicationContext, ScanActivity::class.java)

        val bundle = Bundle().apply {
            putString(SAVE_TO, call.argument<String>(SAVE_TO))
            putString(SCAN_TITLE, call.argument<String>(SCAN_TITLE))
            putString(CROP_TITLE, call.argument<String>(CROP_TITLE))
            putString(CROP_BLACK_WHITE_TITLE, call.argument<String>(CROP_BLACK_WHITE_TITLE))
            putString(CROP_RESET_TITLE, call.argument<String>(CROP_RESET_TITLE))
            putBoolean(CAN_USE_GALLERY, call.argument<Boolean>(CAN_USE_GALLERY) ?: true)
        }

        initialIntent.putExtra(INITIAL_BUNDLE, bundle)

        getActivity()?.startActivityForResult(initialIntent, REQUEST_CODE)
    }

    private fun openGalleryActivity(call: MethodCall, result: Result) {
        if (!setPendingMethodCallAndResult(call, result)) {
            finishWithAlreadyActiveError()
            return
        }
        
        // Store the arguments for later use when gallery image is selected
        val bundle = Bundle().apply {
            putString(SAVE_TO, call.argument<String>(SAVE_TO))
            putString(CROP_TITLE, call.argument<String>(CROP_TITLE))
            putString(CROP_BLACK_WHITE_TITLE, call.argument<String>(CROP_BLACK_WHITE_TITLE))
            putString(CROP_RESET_TITLE, call.argument<String>(CROP_RESET_TITLE))
            putBoolean(FROM_GALLERY, true)
        }
        
        // Store bundle in a temporary location or pass it through intent
        val galleryIntent = Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI).apply {
            type = "image/*"
            putExtra(INITIAL_BUNDLE, bundle)
        }
        
        getActivity()?.startActivityForResult(galleryIntent, REQUEST_CODE)
    }

    private fun setPendingMethodCallAndResult(
        methodCall: MethodCall,
        result: Result
    ): Boolean {
        if (this.result != null) {
            return false
        }
        this.methodCall = methodCall
        this.result = result
        return true
    }

    private fun finishWithAlreadyActiveError() {
        finishWithError("already_active", "Edge detection is already active")
    }

    private fun finishWithError(errorCode: String, errorMessage: String) {
        result?.error(errorCode, errorMessage, null)
        clearMethodCallAndResult()
    }

    private fun finishWithSuccess(res: Boolean) {
        result?.success(res)
        clearMethodCallAndResult()
    }

    private fun clearMethodCallAndResult() {
        methodCall = null
        result = null
    }
} 