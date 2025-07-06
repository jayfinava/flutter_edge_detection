package com.jayfinava.flutteredgedetection


import com.jayfinava.flutteredgedetection.processor.Corners
import org.opencv.core.Mat

class SourceManager {
    companion object {
        var pic: Mat? = null
        var corners: Corners? = null
    }
}