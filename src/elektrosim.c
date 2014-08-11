/* elektrosim.c generated by valac 0.24.0, the Vala compiler
 * generated from elektrosim.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>
#include <gee.h>
#include <float.h>
#include <math.h>


#define ELEKTRO_SIM_TYPE_MAIN_WINDOW (elektro_sim_main_window_get_type ())
#define ELEKTRO_SIM_MAIN_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_MAIN_WINDOW, ElektroSimMainWindow))
#define ELEKTRO_SIM_MAIN_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_MAIN_WINDOW, ElektroSimMainWindowClass))
#define ELEKTRO_SIM_IS_MAIN_WINDOW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_MAIN_WINDOW))
#define ELEKTRO_SIM_IS_MAIN_WINDOW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_MAIN_WINDOW))
#define ELEKTRO_SIM_MAIN_WINDOW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_MAIN_WINDOW, ElektroSimMainWindowClass))

typedef struct _ElektroSimMainWindow ElektroSimMainWindow;
typedef struct _ElektroSimMainWindowClass ElektroSimMainWindowClass;
typedef struct _ElektroSimMainWindowPrivate ElektroSimMainWindowPrivate;

#define ELEKTRO_SIM_TYPE_COMPONENT_LIST (elektro_sim_component_list_get_type ())
#define ELEKTRO_SIM_COMPONENT_LIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_COMPONENT_LIST, ElektroSimComponentList))
#define ELEKTRO_SIM_COMPONENT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_COMPONENT_LIST, ElektroSimComponentListClass))
#define ELEKTRO_SIM_IS_COMPONENT_LIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_COMPONENT_LIST))
#define ELEKTRO_SIM_IS_COMPONENT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_COMPONENT_LIST))
#define ELEKTRO_SIM_COMPONENT_LIST_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_COMPONENT_LIST, ElektroSimComponentListClass))

typedef struct _ElektroSimComponentList ElektroSimComponentList;
typedef struct _ElektroSimComponentListClass ElektroSimComponentListClass;

#define ELEKTRO_SIM_TYPE_SIMULATION_AREA (elektro_sim_simulation_area_get_type ())
#define ELEKTRO_SIM_SIMULATION_AREA(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationArea))
#define ELEKTRO_SIM_SIMULATION_AREA_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationAreaClass))
#define ELEKTRO_SIM_IS_SIMULATION_AREA(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA))
#define ELEKTRO_SIM_IS_SIMULATION_AREA_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_SIMULATION_AREA))
#define ELEKTRO_SIM_SIMULATION_AREA_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationAreaClass))

typedef struct _ElektroSimSimulationArea ElektroSimSimulationArea;
typedef struct _ElektroSimSimulationAreaClass ElektroSimSimulationAreaClass;

#define ELEKTRO_SIM_TYPE_XY_GRAPH (elektro_sim_xy_graph_get_type ())
#define ELEKTRO_SIM_XY_GRAPH(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraph))
#define ELEKTRO_SIM_XY_GRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraphClass))
#define ELEKTRO_SIM_IS_XY_GRAPH(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH))
#define ELEKTRO_SIM_IS_XY_GRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_XY_GRAPH))
#define ELEKTRO_SIM_XY_GRAPH_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraphClass))

typedef struct _ElektroSimXYGraph ElektroSimXYGraph;
typedef struct _ElektroSimXYGraphClass ElektroSimXYGraphClass;

#define ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR (elektro_sim_ng_spice_simulator_get_type ())
#define ELEKTRO_SIM_NG_SPICE_SIMULATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR, ElektroSimNGSpiceSimulator))
#define ELEKTRO_SIM_NG_SPICE_SIMULATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR, ElektroSimNGSpiceSimulatorClass))
#define ELEKTRO_SIM_IS_NG_SPICE_SIMULATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR))
#define ELEKTRO_SIM_IS_NG_SPICE_SIMULATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR))
#define ELEKTRO_SIM_NG_SPICE_SIMULATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_NG_SPICE_SIMULATOR, ElektroSimNGSpiceSimulatorClass))

typedef struct _ElektroSimNGSpiceSimulator ElektroSimNGSpiceSimulator;
typedef struct _ElektroSimNGSpiceSimulatorClass ElektroSimNGSpiceSimulatorClass;
#define _elektro_sim_component_list_unref0(var) ((var == NULL) ? NULL : (var = (elektro_sim_component_list_unref (var), NULL)))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define ELEKTRO_SIM_TYPE_COMPONENT (elektro_sim_component_get_type ())
#define ELEKTRO_SIM_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponent))
#define ELEKTRO_SIM_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))
#define ELEKTRO_SIM_IS_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_IS_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_COMPONENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))

typedef struct _ElektroSimComponent ElektroSimComponent;
typedef struct _ElektroSimComponentClass ElektroSimComponentClass;

#define ELEKTRO_SIM_COMPONENT_TYPE_COMPONENT_TYPE (elektro_sim_component_component_type_get_type ())
#define _g_free0(var) (var = (g_free (var), NULL))

struct _ElektroSimMainWindow {
	GtkWindow parent_instance;
	ElektroSimMainWindowPrivate * priv;
	ElektroSimComponentList* clist;
	ElektroSimSimulationArea* sim_area;
	ElektroSimXYGraph* graph;
	GtkGrid* grid;
	ElektroSimNGSpiceSimulator* gen;
};

struct _ElektroSimMainWindowClass {
	GtkWindowClass parent_class;
};

typedef enum  {
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_COMPONENT,
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_TEMPLATE,
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_SIMULATION
} ElektroSimComponentComponentType;


static gpointer elektro_sim_main_window_parent_class = NULL;

GType elektro_sim_main_window_get_type (void) G_GNUC_CONST;
gpointer elektro_sim_component_list_ref (gpointer instance);
void elektro_sim_component_list_unref (gpointer instance);
GParamSpec* elektro_sim_param_spec_component_list (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void elektro_sim_value_set_component_list (GValue* value, gpointer v_object);
void elektro_sim_value_take_component_list (GValue* value, gpointer v_object);
gpointer elektro_sim_value_get_component_list (const GValue* value);
GType elektro_sim_component_list_get_type (void) G_GNUC_CONST;
GType elektro_sim_simulation_area_get_type (void) G_GNUC_CONST;
GType elektro_sim_xy_graph_get_type (void) G_GNUC_CONST;
GType elektro_sim_ng_spice_simulator_get_type (void) G_GNUC_CONST;
enum  {
	ELEKTRO_SIM_MAIN_WINDOW_DUMMY_PROPERTY
};
gint elektro_sim_main_window_main (gchar** args, int args_length1);
ElektroSimMainWindow* elektro_sim_main_window_new (void);
ElektroSimMainWindow* elektro_sim_main_window_construct (GType object_type);
ElektroSimComponentList* elektro_sim_component_list_new (void);
ElektroSimComponentList* elektro_sim_component_list_construct (GType object_type);
static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self);
ElektroSimSimulationArea* elektro_sim_simulation_area_new (void);
ElektroSimSimulationArea* elektro_sim_simulation_area_construct (GType object_type);
void elektro_sim_component_list_fill_templates (ElektroSimComponentList* self);
ElektroSimXYGraph* elektro_sim_xy_graph_new (void);
ElektroSimXYGraph* elektro_sim_xy_graph_construct (GType object_type);
void elektro_sim_simulation_area_redraw_canvas (ElektroSimSimulationArea* self);
static void _elektro_sim_simulation_area_redraw_canvas_elektro_sim_component_list_request_redraw (ElektroSimComponentList* _sender, gpointer self);
void elektro_sim_xy_graph_set_name (ElektroSimXYGraph* self, const gchar* name);
static void _elektro_sim_xy_graph_set_name_elektro_sim_component_list_selected_values_description_changed (ElektroSimComponentList* _sender, const gchar* name, gpointer self);
void elektro_sim_xy_graph_redraw (ElektroSimXYGraph* self);
static void _elektro_sim_xy_graph_redraw_elektro_sim_component_list_request_graph_redraw (ElektroSimComponentList* _sender, gpointer self);
GType elektro_sim_component_get_type (void) G_GNUC_CONST;
void elektro_sim_component_list_add_component (ElektroSimComponentList* self, ElektroSimComponent* comp);
static void _elektro_sim_component_list_add_component_elektro_sim_simulation_area_new_component (ElektroSimSimulationArea* _sender, ElektroSimComponent* comp, gpointer self);
ElektroSimComponent* elektro_sim_component_list_get_selected_component (ElektroSimComponentList* self);
static ElektroSimComponent* _elektro_sim_component_list_get_selected_component_elektro_sim_simulation_area_request_selected_component (ElektroSimSimulationArea* _sender, gpointer self);
GType elektro_sim_component_component_type_get_type (void) G_GNUC_CONST;
GeeArrayList* elektro_sim_component_list_get_components (ElektroSimComponentList* self, ElektroSimComponentComponentType type2);
static GeeArrayList* _elektro_sim_component_list_get_components_elektro_sim_simulation_area_request_components (ElektroSimSimulationArea* _sender, ElektroSimComponentComponentType type2, gpointer self);
GeeArrayList* elektro_sim_component_list_get_selected_values (ElektroSimComponentList* self, gboolean next);
static GeeArrayList* _elektro_sim_component_list_get_selected_values_elektro_sim_xy_graph_request_selected_component_values (ElektroSimXYGraph* _sender, gboolean next, gpointer self);
GeeArrayList* elektro_sim_component_list_get_time_values (ElektroSimComponentList* self);
static GeeArrayList* _elektro_sim_component_list_get_time_values_elektro_sim_xy_graph_request_time_values (ElektroSimXYGraph* _sender, gpointer self);
ElektroSimNGSpiceSimulator* elektro_sim_ng_spice_simulator_new (void);
ElektroSimNGSpiceSimulator* elektro_sim_ng_spice_simulator_construct (GType object_type);
static GeeArrayList* _elektro_sim_component_list_get_components_elektro_sim_ng_spice_simulator_request_components (ElektroSimNGSpiceSimulator* _sender, ElektroSimComponentComponentType type2, gpointer self);
void elektro_sim_ng_spice_simulator_run_simulation (ElektroSimNGSpiceSimulator* self);
static void _elektro_sim_ng_spice_simulator_run_simulation_elektro_sim_component_list_request_simulation (ElektroSimComponentList* _sender, gpointer self);
void elektro_sim_component_list_set_mode_simulation (ElektroSimComponentList* self);
static void _elektro_sim_component_list_set_mode_simulation_gtk_button_clicked (GtkButton* _sender, gpointer self);
void elektro_sim_component_list_clear (ElektroSimComponentList* self);
static void _elektro_sim_component_list_clear_gtk_button_clicked (GtkButton* _sender, gpointer self);
GtkListBox* elektro_sim_component_list_get_list (ElektroSimComponentList* self);
static void elektro_sim_main_window_finalize (GObject* obj);
void elektro_sim_debug (const gchar* line);


gint elektro_sim_main_window_main (gchar** args, int args_length1) {
	gint result = 0;
	ElektroSimMainWindow* window = NULL;
	ElektroSimMainWindow* _tmp0_ = NULL;
	gtk_init (&args_length1, &args);
	_tmp0_ = elektro_sim_main_window_new ();
	g_object_ref_sink (_tmp0_);
	window = _tmp0_;
	gtk_widget_show_all ((GtkWidget*) window);
	gtk_window_set_decorated ((GtkWindow*) window, TRUE);
	gtk_main ();
	result = 0;
	_g_object_unref0 (window);
	return result;
}


int main (int argc, char ** argv) {
#if !GLIB_CHECK_VERSION (2,35,0)
	g_type_init ();
#endif
	return elektro_sim_main_window_main (argv, argc);
}


static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self) {
	gtk_main_quit ();
}


static void _elektro_sim_simulation_area_redraw_canvas_elektro_sim_component_list_request_redraw (ElektroSimComponentList* _sender, gpointer self) {
	elektro_sim_simulation_area_redraw_canvas ((ElektroSimSimulationArea*) self);
}


static void _elektro_sim_xy_graph_set_name_elektro_sim_component_list_selected_values_description_changed (ElektroSimComponentList* _sender, const gchar* name, gpointer self) {
	elektro_sim_xy_graph_set_name ((ElektroSimXYGraph*) self, name);
}


static void _elektro_sim_xy_graph_redraw_elektro_sim_component_list_request_graph_redraw (ElektroSimComponentList* _sender, gpointer self) {
	elektro_sim_xy_graph_redraw ((ElektroSimXYGraph*) self);
}


static void _elektro_sim_component_list_add_component_elektro_sim_simulation_area_new_component (ElektroSimSimulationArea* _sender, ElektroSimComponent* comp, gpointer self) {
	elektro_sim_component_list_add_component ((ElektroSimComponentList*) self, comp);
}


static ElektroSimComponent* _elektro_sim_component_list_get_selected_component_elektro_sim_simulation_area_request_selected_component (ElektroSimSimulationArea* _sender, gpointer self) {
	ElektroSimComponent* result;
	result = elektro_sim_component_list_get_selected_component ((ElektroSimComponentList*) self);
	return result;
}


static GeeArrayList* _elektro_sim_component_list_get_components_elektro_sim_simulation_area_request_components (ElektroSimSimulationArea* _sender, ElektroSimComponentComponentType type2, gpointer self) {
	GeeArrayList* result;
	result = elektro_sim_component_list_get_components ((ElektroSimComponentList*) self, type2);
	return result;
}


static GeeArrayList* _elektro_sim_component_list_get_selected_values_elektro_sim_xy_graph_request_selected_component_values (ElektroSimXYGraph* _sender, gboolean next, gpointer self) {
	GeeArrayList* result;
	result = elektro_sim_component_list_get_selected_values ((ElektroSimComponentList*) self, next);
	return result;
}


static GeeArrayList* _elektro_sim_component_list_get_time_values_elektro_sim_xy_graph_request_time_values (ElektroSimXYGraph* _sender, gpointer self) {
	GeeArrayList* result;
	result = elektro_sim_component_list_get_time_values ((ElektroSimComponentList*) self);
	return result;
}


static GeeArrayList* _elektro_sim_component_list_get_components_elektro_sim_ng_spice_simulator_request_components (ElektroSimNGSpiceSimulator* _sender, ElektroSimComponentComponentType type2, gpointer self) {
	GeeArrayList* result;
	result = elektro_sim_component_list_get_components ((ElektroSimComponentList*) self, type2);
	return result;
}


static void _elektro_sim_ng_spice_simulator_run_simulation_elektro_sim_component_list_request_simulation (ElektroSimComponentList* _sender, gpointer self) {
	elektro_sim_ng_spice_simulator_run_simulation ((ElektroSimNGSpiceSimulator*) self);
}


static void _elektro_sim_component_list_set_mode_simulation_gtk_button_clicked (GtkButton* _sender, gpointer self) {
	elektro_sim_component_list_set_mode_simulation ((ElektroSimComponentList*) self);
}


static void _elektro_sim_component_list_clear_gtk_button_clicked (GtkButton* _sender, gpointer self) {
	elektro_sim_component_list_clear ((ElektroSimComponentList*) self);
}


ElektroSimMainWindow* elektro_sim_main_window_construct (GType object_type) {
	ElektroSimMainWindow * self = NULL;
	ElektroSimComponentList* _tmp0_ = NULL;
	GtkGrid* _tmp1_ = NULL;
	GtkHeaderBar* header_bar = NULL;
	GtkHeaderBar* _tmp2_ = NULL;
	GtkGrid* _tmp3_ = NULL;
	ElektroSimSimulationArea* _tmp4_ = NULL;
	ElektroSimComponentList* _tmp5_ = NULL;
	ElektroSimXYGraph* _tmp6_ = NULL;
	ElektroSimComponentList* _tmp7_ = NULL;
	ElektroSimSimulationArea* _tmp8_ = NULL;
	ElektroSimComponentList* _tmp9_ = NULL;
	ElektroSimXYGraph* _tmp10_ = NULL;
	ElektroSimComponentList* _tmp11_ = NULL;
	ElektroSimXYGraph* _tmp12_ = NULL;
	ElektroSimSimulationArea* _tmp13_ = NULL;
	ElektroSimComponentList* _tmp14_ = NULL;
	ElektroSimSimulationArea* _tmp15_ = NULL;
	ElektroSimComponentList* _tmp16_ = NULL;
	ElektroSimSimulationArea* _tmp17_ = NULL;
	ElektroSimComponentList* _tmp18_ = NULL;
	ElektroSimXYGraph* _tmp19_ = NULL;
	ElektroSimComponentList* _tmp20_ = NULL;
	ElektroSimXYGraph* _tmp21_ = NULL;
	ElektroSimComponentList* _tmp22_ = NULL;
	ElektroSimNGSpiceSimulator* _tmp23_ = NULL;
	ElektroSimNGSpiceSimulator* _tmp24_ = NULL;
	ElektroSimComponentList* _tmp25_ = NULL;
	GtkButton* design_button = NULL;
	GtkButton* _tmp26_ = NULL;
	GtkButton* sim_button = NULL;
	GtkButton* _tmp27_ = NULL;
	ElektroSimComponentList* _tmp28_ = NULL;
	ElektroSimNGSpiceSimulator* _tmp29_ = NULL;
	ElektroSimComponentList* _tmp30_ = NULL;
	GtkButton* clear_button = NULL;
	GtkButton* _tmp31_ = NULL;
	ElektroSimComponentList* _tmp32_ = NULL;
	GtkScrolledWindow* scrolled = NULL;
	GtkScrolledWindow* _tmp33_ = NULL;
	ElektroSimComponentList* _tmp34_ = NULL;
	GtkListBox* _tmp35_ = NULL;
	GtkListBox* _tmp36_ = NULL;
	GtkGrid* _tmp37_ = NULL;
	GtkGrid* _tmp38_ = NULL;
	ElektroSimSimulationArea* _tmp39_ = NULL;
	GtkGrid* _tmp40_ = NULL;
	ElektroSimXYGraph* _tmp41_ = NULL;
	ElektroSimSimulationArea* _tmp42_ = NULL;
	GtkGrid* _tmp43_ = NULL;
	self = (ElektroSimMainWindow*) g_object_new (object_type, NULL);
	gtk_window_set_title ((GtkWindow*) self, "ElektroSim");
	_tmp0_ = elektro_sim_component_list_new ();
	_elektro_sim_component_list_unref0 (self->clist);
	self->clist = _tmp0_;
	_tmp1_ = (GtkGrid*) gtk_grid_new ();
	g_object_ref_sink (_tmp1_);
	_g_object_unref0 (self->grid);
	self->grid = _tmp1_;
	gtk_container_set_border_width ((GtkContainer*) self, (guint) 1);
	gtk_window_set_default_size ((GtkWindow*) self, 1400, 800);
	gtk_window_maximize ((GtkWindow*) self);
	g_object_set ((GtkWindow*) self, "window-position", GTK_WIN_POS_CENTER, NULL);
	g_signal_connect ((GtkWidget*) self, "destroy", (GCallback) _gtk_main_quit_gtk_widget_destroy, NULL);
	_tmp2_ = (GtkHeaderBar*) gtk_header_bar_new ();
	g_object_ref_sink (_tmp2_);
	header_bar = _tmp2_;
	_tmp3_ = self->grid;
	gtk_container_add ((GtkContainer*) self, (GtkWidget*) _tmp3_);
	gtk_widget_set_halign ((GtkWidget*) header_bar, GTK_ALIGN_FILL);
	gtk_header_bar_set_show_close_button (header_bar, TRUE);
	gtk_widget_set_visible ((GtkWidget*) header_bar, TRUE);
	_tmp4_ = elektro_sim_simulation_area_new ();
	g_object_ref_sink (_tmp4_);
	_g_object_unref0 (self->sim_area);
	self->sim_area = _tmp4_;
	_tmp5_ = self->clist;
	elektro_sim_component_list_fill_templates (_tmp5_);
	_tmp6_ = elektro_sim_xy_graph_new ();
	g_object_ref_sink (_tmp6_);
	_g_object_unref0 (self->graph);
	self->graph = _tmp6_;
	_tmp7_ = self->clist;
	_tmp8_ = self->sim_area;
	g_signal_connect_object (_tmp7_, "request-redraw", (GCallback) _elektro_sim_simulation_area_redraw_canvas_elektro_sim_component_list_request_redraw, _tmp8_, 0);
	_tmp9_ = self->clist;
	_tmp10_ = self->graph;
	g_signal_connect_object (_tmp9_, "selected-values-description-changed", (GCallback) _elektro_sim_xy_graph_set_name_elektro_sim_component_list_selected_values_description_changed, _tmp10_, 0);
	_tmp11_ = self->clist;
	_tmp12_ = self->graph;
	g_signal_connect_object (_tmp11_, "request-graph-redraw", (GCallback) _elektro_sim_xy_graph_redraw_elektro_sim_component_list_request_graph_redraw, _tmp12_, 0);
	_tmp13_ = self->sim_area;
	_tmp14_ = self->clist;
	g_signal_connect (_tmp13_, "new-component", (GCallback) _elektro_sim_component_list_add_component_elektro_sim_simulation_area_new_component, _tmp14_);
	_tmp15_ = self->sim_area;
	_tmp16_ = self->clist;
	g_signal_connect (_tmp15_, "request-selected-component", (GCallback) _elektro_sim_component_list_get_selected_component_elektro_sim_simulation_area_request_selected_component, _tmp16_);
	_tmp17_ = self->sim_area;
	_tmp18_ = self->clist;
	g_signal_connect (_tmp17_, "request-components", (GCallback) _elektro_sim_component_list_get_components_elektro_sim_simulation_area_request_components, _tmp18_);
	_tmp19_ = self->graph;
	_tmp20_ = self->clist;
	g_signal_connect (_tmp19_, "request-selected-component-values", (GCallback) _elektro_sim_component_list_get_selected_values_elektro_sim_xy_graph_request_selected_component_values, _tmp20_);
	_tmp21_ = self->graph;
	_tmp22_ = self->clist;
	g_signal_connect (_tmp21_, "request-time-values", (GCallback) _elektro_sim_component_list_get_time_values_elektro_sim_xy_graph_request_time_values, _tmp22_);
	_tmp23_ = elektro_sim_ng_spice_simulator_new ();
	_g_object_unref0 (self->gen);
	self->gen = _tmp23_;
	_tmp24_ = self->gen;
	_tmp25_ = self->clist;
	g_signal_connect (_tmp24_, "request-components", (GCallback) _elektro_sim_component_list_get_components_elektro_sim_ng_spice_simulator_request_components, _tmp25_);
	_tmp26_ = (GtkButton*) gtk_button_new_with_label ("Design");
	g_object_ref_sink (_tmp26_);
	design_button = _tmp26_;
	gtk_container_add ((GtkContainer*) header_bar, (GtkWidget*) design_button);
	_tmp27_ = (GtkButton*) gtk_button_new_with_label ("Simulation");
	g_object_ref_sink (_tmp27_);
	sim_button = _tmp27_;
	_tmp28_ = self->clist;
	_tmp29_ = self->gen;
	g_signal_connect_object (_tmp28_, "request-simulation", (GCallback) _elektro_sim_ng_spice_simulator_run_simulation_elektro_sim_component_list_request_simulation, _tmp29_, 0);
	_tmp30_ = self->clist;
	g_signal_connect (sim_button, "clicked", (GCallback) _elektro_sim_component_list_set_mode_simulation_gtk_button_clicked, _tmp30_);
	gtk_container_add ((GtkContainer*) header_bar, (GtkWidget*) sim_button);
	_tmp31_ = (GtkButton*) gtk_button_new_with_label ("Clear");
	g_object_ref_sink (_tmp31_);
	clear_button = _tmp31_;
	_tmp32_ = self->clist;
	g_signal_connect (clear_button, "clicked", (GCallback) _elektro_sim_component_list_clear_gtk_button_clicked, _tmp32_);
	gtk_container_add ((GtkContainer*) header_bar, (GtkWidget*) clear_button);
	_tmp33_ = (GtkScrolledWindow*) gtk_scrolled_window_new (NULL, NULL);
	g_object_ref_sink (_tmp33_);
	scrolled = _tmp33_;
	gtk_scrolled_window_set_min_content_width (scrolled, 300);
	gtk_widget_set_hexpand ((GtkWidget*) scrolled, FALSE);
	_tmp34_ = self->clist;
	_tmp35_ = elektro_sim_component_list_get_list (_tmp34_);
	_tmp36_ = _tmp35_;
	gtk_container_add ((GtkContainer*) scrolled, (GtkWidget*) _tmp36_);
	_tmp37_ = self->grid;
	gtk_grid_attach (_tmp37_, (GtkWidget*) scrolled, 0, 0, 1, 4);
	_tmp38_ = self->grid;
	_tmp39_ = self->sim_area;
	gtk_grid_attach_next_to (_tmp38_, (GtkWidget*) _tmp39_, (GtkWidget*) scrolled, GTK_POS_RIGHT, 4, 3);
	_tmp40_ = self->grid;
	_tmp41_ = self->graph;
	_tmp42_ = self->sim_area;
	gtk_grid_attach_next_to (_tmp40_, (GtkWidget*) _tmp41_, (GtkWidget*) _tmp42_, GTK_POS_BOTTOM, 4, 1);
	_tmp43_ = self->grid;
	gtk_grid_set_column_homogeneous (_tmp43_, FALSE);
	gtk_window_set_titlebar ((GtkWindow*) self, (GtkWidget*) header_bar);
	_g_object_unref0 (scrolled);
	_g_object_unref0 (clear_button);
	_g_object_unref0 (sim_button);
	_g_object_unref0 (design_button);
	_g_object_unref0 (header_bar);
	return self;
}


ElektroSimMainWindow* elektro_sim_main_window_new (void) {
	return elektro_sim_main_window_construct (ELEKTRO_SIM_TYPE_MAIN_WINDOW);
}


static void elektro_sim_main_window_class_init (ElektroSimMainWindowClass * klass) {
	elektro_sim_main_window_parent_class = g_type_class_peek_parent (klass);
	G_OBJECT_CLASS (klass)->finalize = elektro_sim_main_window_finalize;
}


static void elektro_sim_main_window_instance_init (ElektroSimMainWindow * self) {
}


static void elektro_sim_main_window_finalize (GObject* obj) {
	ElektroSimMainWindow * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, ELEKTRO_SIM_TYPE_MAIN_WINDOW, ElektroSimMainWindow);
	_elektro_sim_component_list_unref0 (self->clist);
	_g_object_unref0 (self->sim_area);
	_g_object_unref0 (self->graph);
	_g_object_unref0 (self->grid);
	_g_object_unref0 (self->gen);
	G_OBJECT_CLASS (elektro_sim_main_window_parent_class)->finalize (obj);
}


GType elektro_sim_main_window_get_type (void) {
	static volatile gsize elektro_sim_main_window_type_id__volatile = 0;
	if (g_once_init_enter (&elektro_sim_main_window_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ElektroSimMainWindowClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) elektro_sim_main_window_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ElektroSimMainWindow), 0, (GInstanceInitFunc) elektro_sim_main_window_instance_init, NULL };
		GType elektro_sim_main_window_type_id;
		elektro_sim_main_window_type_id = g_type_register_static (GTK_TYPE_WINDOW, "ElektroSimMainWindow", &g_define_type_info, 0);
		g_once_init_leave (&elektro_sim_main_window_type_id__volatile, elektro_sim_main_window_type_id);
	}
	return elektro_sim_main_window_type_id__volatile;
}


void elektro_sim_debug (const gchar* line) {
	gboolean debug = FALSE;
	gboolean _tmp0_ = FALSE;
	g_return_if_fail (line != NULL);
	debug = FALSE;
	_tmp0_ = debug;
	if (_tmp0_) {
		const gchar* _tmp1_ = NULL;
		gchar* _tmp2_ = NULL;
		gchar* _tmp3_ = NULL;
		_tmp1_ = line;
		_tmp2_ = g_strconcat (_tmp1_, "\n", NULL);
		_tmp3_ = _tmp2_;
		g_print ("%s", _tmp3_);
		_g_free0 (_tmp3_);
	}
}



