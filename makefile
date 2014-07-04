all:
	valac -g -v --pkg=ngspice  --vapidir=./ --pkg gtk+-3.0 --pkg gee-0.8 --pkg librsvg-2.0 *.vala -o elektroSim -X '-lngspice'
