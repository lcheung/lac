ADD_LIBRARY(touchlib IBlobTracker.cpp ThresholdFilter.cpp ShapeFilter.cpp SimpleHighpassFilter.cpp HighpassFilter.cpp InvertFilter.cpp ScalerFilter.cpp BackgroundFilter.cpp BrightnessContrastFilter.cpp CBlobTracker.cpp CTouchScreen.cpp CvCaptureFilter.cpp filter.cpp FilterFactory.cpp MonoFilter.cpp RectifyFilter.cpp ResizeFilter.cpp CropFilter.cpp BarrelDistortionCorrectionFilter.cpp SmoothingFilter.cpp  TouchScreenDevice.cpp  )

ADD_EXECUTABLE(sampleapp sampleapp.cpp)
TARGET_LINK_LIBRARIES(sampleapp touchlib tinyxml ${OpenCV_LIBRARIES})

IF(OPENGL_FOUND AND GLUT_FOUND)
	ADD_EXECUTABLE(configapp configapp.cpp)
	TARGET_LINK_LIBRARIES(configapp touchlib tinyxml ${OPENGL_LIBRARIES} ${GLUT_LIBRARIES} ${OpenCV_LIBRARIES})
#	SET_TARGET_PROPERTIES(configapp
#			PROPERTIES LINK_FLAGS ${OPENCV_LINKDIR} LINK_FLAGS ${OPENCV_LDFLAGS})
ENDIF(OPENGL_FOUND AND GLUT_FOUND)
