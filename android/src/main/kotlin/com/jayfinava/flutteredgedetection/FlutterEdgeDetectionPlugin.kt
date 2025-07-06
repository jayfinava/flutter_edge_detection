package com.jayfinava.flutteredgedetection

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import com.jayfinava.flutteredgedetection.EdgeDetectionHandler

class FlutterEdgeDetectionPlugin : FlutterPlugin, ActivityAware {
    private var handler: EdgeDetectionHandler? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        handler = EdgeDetectionHandler()
        val channel = MethodChannel(
            binding.binaryMessenger, "flutter_edge_detection"
        )
        channel.setMethodCallHandler(handler)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        handler = null
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        handler?.setActivityPluginBinding(activityPluginBinding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        handler?.setActivityPluginBinding(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        handler?.setActivityPluginBinding(binding)
    }

    override fun onDetachedFromActivity() {
        handler?.setActivityPluginBinding(null)
    }
} 