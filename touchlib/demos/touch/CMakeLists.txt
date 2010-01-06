ADD_EXECUTABLE(touch touch.cpp)
	TARGET_LINK_LIBRARIES(touch touchlib tinyxml ${OpenCV_LIBRARIES} )
