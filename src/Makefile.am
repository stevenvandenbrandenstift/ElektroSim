## Process this file with automake to produce Makefile.in

## Created by Anjuta



AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir). \
	$(GEE_CFLAGS)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(ELEKTROSIM_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = elektrosim

elektrosim_SOURCES = \
	elektrosim.vala config.vapi component.vala simulationArea.vala resistor.vala ground.vala power-source.vala netlist-generator.vala

elektrosim_VALAFLAGS =  \
	--pkg gtk+-3.0 --pkg gee-0.8


elektrosim_LDFLAGS = \
	-Wl,--export-dynamic

elektrosim_LDADD = $(ELEKTROSIM_LIBS) \
	$(GEE_LIBS)




