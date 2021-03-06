# Find Wt includes and libraries
#
# This script sets the following variables:
#
#  Wt_INCLUDE_DIR
#  Wt_LIBRARIES  - Release libraries
#  Wt_FOUND  - True if release libraries found
#

set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${CMAKE_INSTALL_PREFIX}/../Wt")
set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${CMAKE_INSTALL_PREFIX}/../Wt")
FIND_PATH( Wt_INCLUDE_DIR NAMES Wt/WObject PATHS PATH PATH_SUFFIXES include wt )
message ("Wt_INCLUDE_DIR ${Wt_INCLUDE_DIR}")

IF( Wt_INCLUDE_DIR )
  FIND_LIBRARY( Wt_LIBRARY NAMES wt PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_HTTP_LIBRARY NAMES wthttp PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_FCGI_LIBRARY NAMES wtfcgi PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_ISAPI_LIBRARY NAMES wtisapi PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_DBO_LIBRARY NAMES wtdbo PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_DBOSQLITE3_LIBRARY NAMES wtdbosqlite3 PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_DBOPOSTGRES_LIBRARY NAMES wtdbopostgres PATHS PATH PATH_SUFFIXES lib lib-release lib_release )
  FIND_LIBRARY( Wt_TEST_LIBRARY NAMES wttest PATHS PATH PATH_SUFFIXES lib lib-release lib_release )


  IF( Wt_LIBRARY AND Wt_HTTP_LIBRARY)
    SET( Wt_FOUND TRUE )
    SET( Wt_LIBRARIES ${Wt_HTTP_LIBRARY} ${Wt_LIBRARY} )
  ENDIF()

  IF( Wt_DBO_LIBRARY )
    SET( Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_DBO_LIBRARY} )
    IF( Wt_DBOSQLITE3_LIBRARY )
      SET( Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_DBOSQLITE3_LIBRARY} )
    ENDIF()
    IF( Wt_DBOPOSTGRES_LIBRARY )
      SET( Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_DBOPOSTGRES_LIBRARY} )
    ENDIF()
  ENDIF( Wt_DBO_LIBRARY )

  IF(Wt_CONNECTOR STREQUAL "isapi")
    SET( Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_ISAPI_LIBRARY} )
  ELSEIF(Wt_CONNECTOR STREQUAL "fcgi")
    SET( Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_FCGI_LIBRARY} )
  ENDIF()

  IF(Wt_FOUND)
    IF (NOT Wt_FIND_QUIETLY)
      MESSAGE(STATUS "Found the Wt libraries at ${Wt_LIBRARIES}")
      MESSAGE(STATUS "Found the Wt headers at ${Wt_INCLUDE_DIR}")
    ENDIF (NOT Wt_FIND_QUIETLY)
  ELSE(Wt_FOUND)
    IF(Wt_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could NOT find Wt")
    ENDIF(Wt_FIND_REQUIRED)
  ENDIF(Wt_FOUND)
ENDIF( Wt_INCLUDE_DIR )
