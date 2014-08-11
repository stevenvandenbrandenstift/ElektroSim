## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(ELEKTROSIM_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = elektrosim

elektrosim_SOURCES = \
	config.vapi capicitor.vala component.vala componentlist.vala ground.vala inductor.vala Line.vala NGSpiceSimulator.vala parameter.vala point.vala power-source.vala resistor.vala simulation.vala simulationArea.vala XYGraph.vala elektrosim.vala

elektrosim_VALAFLAGS =  --pkg librsvg-2.0 --pkg ngspice --pkg gee-0.8  \
	--pkg gtk+-3.0


elektrosim_LDFLAGS =

elektrosim_LDADD = $(ELEKTROSIM_LIBS)


if PLATFORM_WIN32
elektrosim_LDFLAGS += -Wl,--export-all-symbols
else
elektrosim_LDFLAGS += -Wl,--export-dynamic
endif

if NATIVE_WIN32
elektrosim_LDFLAGS += -mwindows
endif


