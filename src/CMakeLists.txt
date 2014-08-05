### CMakeLists automatically created with AutoVala
### Do not edit

set (DATADIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATAROOTDIR}")
set (PKGDATADIR "${DATADIR}/elektrosim")
set (GETTEXT_PACKAGE "elektrosim")
set (RELEASE_NAME "elektrosim")
set (CMAKE_C_FLAGS "")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (VERSION "1.0.0")
set (DOLLAR "$")

configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_BINARY_DIR}/src/Config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
set (VERSION "1.0.0")
add_definitions (${DEPS_CFLAGS})
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.24" MINIMUM)
include (ValaPrecompile)

set (VALA_PACKAGES ${VALA_PACKAGES} atk)
set (VALA_PACKAGES ${VALA_PACKAGES} cairo)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gdk-pixbuf-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gee-0.8)
set (VALA_PACKAGES ${VALA_PACKAGES} gio-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} glib-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gobject-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} gtk+-3.0)
set (VALA_PACKAGES ${VALA_PACKAGES} librsvg-2.0)
set (VALA_PACKAGES ${VALA_PACKAGES} ngspice)
set (VALA_PACKAGES ${VALA_PACKAGES} pango)
set (VALA_PACKAGES ${VALA_PACKAGES} pangocairo)
set (VALA_PACKAGES ${VALA_PACKAGES} x11)

set (APP_SOURCES ${APP_SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/Config.vala)
set (APP_SOURCES ${APP_SOURCES} Line.vala)
set (APP_SOURCES ${APP_SOURCES} NGSpiceSimulator.vala)
set (APP_SOURCES ${APP_SOURCES} XYGraph.vala)
set (APP_SOURCES ${APP_SOURCES} capicitor.vala)
set (APP_SOURCES ${APP_SOURCES} component.vala)
set (APP_SOURCES ${APP_SOURCES} componentlist.vala)
set (APP_SOURCES ${APP_SOURCES} elektrosim.vala)
set (APP_SOURCES ${APP_SOURCES} ground.vala)
set (APP_SOURCES ${APP_SOURCES} inductor.vala)
set (APP_SOURCES ${APP_SOURCES} parameter.vala)
set (APP_SOURCES ${APP_SOURCES} point.vala)
set (APP_SOURCES ${APP_SOURCES} power-source.vala)
set (APP_SOURCES ${APP_SOURCES} resistor.vala)
set (APP_SOURCES ${APP_SOURCES} simulation.vala)
set (APP_SOURCES ${APP_SOURCES} simulationArea.vala)

vala_precompile(VALA_C elektrosim
	${APP_SOURCES}
PACKAGES
	${VALA_PACKAGES}
)

add_executable(elektrosim ${VALA_C})

install(TARGETS
	elektrosim
RUNTIME DESTINATION
	${CMAKE_INSTALL_BINDIR}/
)

if(HAVE_VALADOC)
	valadoc(elektrosim
		${CMAKE_BINARY_DIR}/valadoc/elektrosim
		${APP_SOURCES}
	PACKAGES
		${VALA_PACKAGES}
	CUSTOM_VAPIS
		${CUSTOM_VAPIS_LIST}
	)
	install(DIRECTORY
		${CMAKE_BINARY_DIR}/valadoc
	DESTINATION
		${CMAKE_INSTALL_DATAROOTDIR}/doc/elektrosim
	)
endif()
