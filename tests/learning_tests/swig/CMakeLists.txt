# Include headers
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/src)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

# Enumerate source files
FILE(GLOB TEST_SRC_FILES *.cpp)
FILE(GLOB TEST_INC_FILES *.h)

ADD_LIBRARY(lib_swig_tests SHARED ${TEST_SRC_FILES} ${TEST_INC_FILES})
TARGET_LINK_LIBRARIES(lib_swig_tests Mesh)

SET(SWG_FILES PySwigTests.i)

# Add swig wrapper for the library
FIND_PACKAGE(SWIG REQUIRED)
INCLUDE(UseSWIG)

# Find python
IF ((NOT DEFINED ENV{PYTHON_INCLUDE_DIRS}) OR (NOT DEFINED ENV{PYTHON_LIBRARIES}))
    FIND_PACKAGE(PythonLibs)
ELSE ((NOT DEFINED ENV{PYTHON_INCLUDE_DIRS}) OR (NOT DEFINED ENV{PYTHON_LIBRARIES}))
    SET(PYTHON_INCLUDE_DIRS $ENV{PYTHON_INCLUDE_DIRS})
    SET(PYTHON_LIBRARIES $ENV{PYTHON_LIBRARIES})
ENDIF ((NOT DEFINED ENV{PYTHON_INCLUDE_DIRS}) OR (NOT DEFINED ENV{PYTHON_LIBRARIES}))
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_DIRS})

# Find numpy
FIND_PACKAGE("NumPy")
INCLUDE_DIRECTORIES(${NUMPY_INCLUDE_DIRS})

# Add eigen wrapper
INCLUDE_DIRECTORIES(${EIGEN_WRAPPER_PATH})

# Generate wrapper for python
SET_SOURCE_FILES_PROPERTIES(${SWG_FILES} PROPERTIES CPLUSPLUS ON)
SET_SOURCE_FILES_PROPERTIES(${SWG_FILES} PROPERTIES CMAKE_SWIG_FLAGS "-includeall")
SWIG_ADD_MODULE(PySwigTests python ${SWG_FILES} ${TEST_INC_FILES})
SWIG_LINK_LIBRARIES(PySwigTests ${PYTHON_LIBRARIES} Mesh lib_swig_tests)
ADD_CUSTOM_COMMAND(TARGET _PySwigTests POST_BUILD COMMAND
    "${CMAKE_CURRENT_SOURCE_DIR}/unit_test_driver.py")

ADD_CUSTOM_TARGET(swig_tests DEPENDS lib_swig_tests _PySwigTests)
