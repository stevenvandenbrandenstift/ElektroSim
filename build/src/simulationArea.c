/* simulationArea.c generated by valac 0.24.0, the Vala compiler
 * generated from simulationArea.vala, do not modify */

/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * simulationArea.vala
 * Copyright (C) 2014 Steven Vanden Branden <Stevenvandenbrandenstift@gmail.com>
 *
 * ElektroSim is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * ElektroSim is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <cairo.h>
#include <float.h>
#include <math.h>
#include <gee.h>


#define ELEKTRO_SIM_TYPE_SIMULATION_AREA (elektro_sim_simulation_area_get_type ())
#define ELEKTRO_SIM_SIMULATION_AREA(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationArea))
#define ELEKTRO_SIM_SIMULATION_AREA_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationAreaClass))
#define ELEKTRO_SIM_IS_SIMULATION_AREA(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA))
#define ELEKTRO_SIM_IS_SIMULATION_AREA_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_SIMULATION_AREA))
#define ELEKTRO_SIM_SIMULATION_AREA_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_SIMULATION_AREA, ElektroSimSimulationAreaClass))

typedef struct _ElektroSimSimulationArea ElektroSimSimulationArea;
typedef struct _ElektroSimSimulationAreaClass ElektroSimSimulationAreaClass;
typedef struct _ElektroSimSimulationAreaPrivate ElektroSimSimulationAreaPrivate;

#define ELEKTRO_SIM_TYPE_COMPONENT (elektro_sim_component_get_type ())
#define ELEKTRO_SIM_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponent))
#define ELEKTRO_SIM_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))
#define ELEKTRO_SIM_IS_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_IS_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_COMPONENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))

typedef struct _ElektroSimComponent ElektroSimComponent;
typedef struct _ElektroSimComponentClass ElektroSimComponentClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define ELEKTRO_SIM_COMPONENT_TYPE_COMPONENT_TYPE (elektro_sim_component_component_type_get_type ())

#define ELEKTRO_SIM_TYPE_LINE (elektro_sim_line_get_type ())
#define ELEKTRO_SIM_LINE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_LINE, ElektroSimLine))
#define ELEKTRO_SIM_LINE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_LINE, ElektroSimLineClass))
#define ELEKTRO_SIM_IS_LINE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_LINE))
#define ELEKTRO_SIM_IS_LINE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_LINE))
#define ELEKTRO_SIM_LINE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_LINE, ElektroSimLineClass))

typedef struct _ElektroSimLine ElektroSimLine;
typedef struct _ElektroSimLineClass ElektroSimLineClass;
#define _cairo_region_destroy0(var) ((var == NULL) ? NULL : (var = (cairo_region_destroy (var), NULL)))

struct _ElektroSimSimulationArea {
	GtkDrawingArea parent_instance;
	ElektroSimSimulationAreaPrivate * priv;
};

struct _ElektroSimSimulationAreaClass {
	GtkDrawingAreaClass parent_class;
};

typedef enum  {
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_COMPONENT,
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_TEMPLATE,
	ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_SIMULATION
} ElektroSimComponentComponentType;


static gpointer elektro_sim_simulation_area_parent_class = NULL;

GType elektro_sim_simulation_area_get_type (void) G_GNUC_CONST;
enum  {
	ELEKTRO_SIM_SIMULATION_AREA_DUMMY_PROPERTY
};
ElektroSimSimulationArea* elektro_sim_simulation_area_new (void);
ElektroSimSimulationArea* elektro_sim_simulation_area_construct (GType object_type);
static gboolean __lambda15_ (ElektroSimSimulationArea* self, GdkEventButton* event);
GType elektro_sim_component_get_type (void) G_GNUC_CONST;
static void elektro_sim_simulation_area_insert_component (ElektroSimSimulationArea* self, gint x, gint y, ElektroSimComponent* component);
static gboolean ___lambda15__gtk_widget_button_press_event (GtkWidget* _sender, GdkEventButton* event, gpointer self);
static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self);
static gboolean elektro_sim_simulation_area_real_draw (GtkWidget* base, cairo_t* cr);
GType elektro_sim_component_component_type_get_type (void) G_GNUC_CONST;
void elektro_sim_component_draw_image (ElektroSimComponent* self, cairo_t* cr);
GType elektro_sim_line_get_type (void) G_GNUC_CONST;
gboolean elektro_sim_line_get_second_point_needed (ElektroSimLine* self);
ElektroSimComponent* elektro_sim_component_clone (ElektroSimComponent* self);
void elektro_sim_component_snap (ElektroSimComponent* self, gint range, gint x, gint y);
void elektro_sim_simulation_area_redraw_canvas (ElektroSimSimulationArea* self);
static void g_cclosure_user_marshal_OBJECT__ENUM (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data);
static void g_cclosure_user_marshal_OBJECT__VOID (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data);


static gboolean __lambda15_ (ElektroSimSimulationArea* self, GdkEventButton* event) {
	gboolean result = FALSE;
	GdkEventButton* _tmp0_ = NULL;
	gdouble _tmp1_ = 0.0;
	GdkEventButton* _tmp2_ = NULL;
	gdouble _tmp3_ = 0.0;
	ElektroSimComponent* _tmp4_ = NULL;
	ElektroSimComponent* _tmp5_ = NULL;
	g_return_val_if_fail (event != NULL, FALSE);
	_tmp0_ = event;
	_tmp1_ = _tmp0_->x;
	_tmp2_ = event;
	_tmp3_ = _tmp2_->y;
	g_signal_emit_by_name (self, "request-selected-component", &_tmp4_);
	_tmp5_ = _tmp4_;
	elektro_sim_simulation_area_insert_component (self, (gint) _tmp1_, (gint) _tmp3_, _tmp5_);
	_g_object_unref0 (_tmp5_);
	result = TRUE;
	return result;
}


static gboolean ___lambda15__gtk_widget_button_press_event (GtkWidget* _sender, GdkEventButton* event, gpointer self) {
	gboolean result;
	result = __lambda15_ ((ElektroSimSimulationArea*) self, event);
	return result;
}


static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self) {
	gtk_main_quit ();
}


ElektroSimSimulationArea* elektro_sim_simulation_area_construct (GType object_type) {
	ElektroSimSimulationArea * self = NULL;
	self = (ElektroSimSimulationArea*) g_object_new (object_type, NULL);
	gtk_widget_add_events ((GtkWidget*) self, (gint) GDK_BUTTON_PRESS_MASK);
	g_signal_connect_object ((GtkWidget*) self, "button-press-event", (GCallback) ___lambda15__gtk_widget_button_press_event, self, 0);
	g_signal_connect ((GtkWidget*) self, "destroy", (GCallback) _gtk_main_quit_gtk_widget_destroy, NULL);
	gtk_widget_set_vexpand ((GtkWidget*) self, TRUE);
	gtk_widget_set_hexpand ((GtkWidget*) self, TRUE);
	return self;
}


ElektroSimSimulationArea* elektro_sim_simulation_area_new (void) {
	return elektro_sim_simulation_area_construct (ELEKTRO_SIM_TYPE_SIMULATION_AREA);
}


static gboolean elektro_sim_simulation_area_real_draw (GtkWidget* base, cairo_t* cr) {
	ElektroSimSimulationArea * self;
	gboolean result = FALSE;
	cairo_t* _tmp0_ = NULL;
	cairo_t* _tmp1_ = NULL;
	cairo_t* _tmp2_ = NULL;
	cairo_t* _tmp3_ = NULL;
	cairo_t* _tmp4_ = NULL;
	cairo_t* _tmp5_ = NULL;
	cairo_t* _tmp6_ = NULL;
	cairo_t* _tmp7_ = NULL;
	self = (ElektroSimSimulationArea*) base;
	g_return_val_if_fail (cr != NULL, FALSE);
	_tmp0_ = cr;
	cairo_new_path (_tmp0_);
	_tmp1_ = cr;
	cairo_set_source_rgb (_tmp1_, 0.5, 0.5, 0.5);
	_tmp2_ = cr;
	cairo_fill (_tmp2_);
	_tmp3_ = cr;
	cairo_close_path (_tmp3_);
	_tmp4_ = cr;
	cairo_paint (_tmp4_);
	_tmp5_ = cr;
	cairo_set_source_rgb (_tmp5_, (gdouble) 200, (gdouble) 200, (gdouble) 200);
	_tmp6_ = cr;
	cairo_set_line_width (_tmp6_, (gdouble) 3);
	_tmp7_ = cr;
	cairo_select_font_face (_tmp7_, "Adventure", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
	{
		GeeArrayList* _component_list = NULL;
		GeeArrayList* _tmp8_ = NULL;
		gint _component_size = 0;
		GeeArrayList* _tmp9_ = NULL;
		gint _tmp10_ = 0;
		gint _tmp11_ = 0;
		gint _component_index = 0;
		g_signal_emit_by_name (self, "request-components", ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_COMPONENT, &_tmp8_);
		_component_list = _tmp8_;
		_tmp9_ = _component_list;
		_tmp10_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp9_);
		_tmp11_ = _tmp10_;
		_component_size = _tmp11_;
		_component_index = -1;
		while (TRUE) {
			gint _tmp12_ = 0;
			gint _tmp13_ = 0;
			gint _tmp14_ = 0;
			ElektroSimComponent* component = NULL;
			GeeArrayList* _tmp15_ = NULL;
			gint _tmp16_ = 0;
			gpointer _tmp17_ = NULL;
			ElektroSimComponent* _tmp18_ = NULL;
			cairo_t* _tmp19_ = NULL;
			_tmp12_ = _component_index;
			_component_index = _tmp12_ + 1;
			_tmp13_ = _component_index;
			_tmp14_ = _component_size;
			if (!(_tmp13_ < _tmp14_)) {
				break;
			}
			_tmp15_ = _component_list;
			_tmp16_ = _component_index;
			_tmp17_ = gee_abstract_list_get ((GeeAbstractList*) _tmp15_, _tmp16_);
			component = (ElektroSimComponent*) _tmp17_;
			_tmp18_ = component;
			_tmp19_ = cr;
			elektro_sim_component_draw_image (_tmp18_, _tmp19_);
			_g_object_unref0 (component);
		}
		_g_object_unref0 (_component_list);
	}
	result = TRUE;
	return result;
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


static void elektro_sim_simulation_area_insert_component (ElektroSimSimulationArea* self, gint x, gint y, ElektroSimComponent* component) {
	ElektroSimComponent* newComponent = NULL;
	ElektroSimComponent* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	const gchar* _tmp2_ = NULL;
	ElektroSimComponent* _tmp22_ = NULL;
	ElektroSimComponent* _tmp25_ = NULL;
	gint _tmp26_ = 0;
	gint _tmp27_ = 0;
	ElektroSimComponent* _tmp28_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (component != NULL);
	newComponent = NULL;
	_tmp0_ = component;
	_tmp1_ = gtk_widget_get_name ((GtkWidget*) _tmp0_);
	_tmp2_ = _tmp1_;
	if (g_strcmp0 (_tmp2_, "Line") == 0) {
		{
			GeeArrayList* _component2_list = NULL;
			GeeArrayList* _tmp3_ = NULL;
			gint _component2_size = 0;
			GeeArrayList* _tmp4_ = NULL;
			gint _tmp5_ = 0;
			gint _tmp6_ = 0;
			gint _component2_index = 0;
			g_signal_emit_by_name (self, "request-components", ELEKTRO_SIM_COMPONENT_COMPONENT_TYPE_COMPONENT, &_tmp3_);
			_component2_list = _tmp3_;
			_tmp4_ = _component2_list;
			_tmp5_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp4_);
			_tmp6_ = _tmp5_;
			_component2_size = _tmp6_;
			_component2_index = -1;
			while (TRUE) {
				gint _tmp7_ = 0;
				gint _tmp8_ = 0;
				gint _tmp9_ = 0;
				ElektroSimComponent* component2 = NULL;
				GeeArrayList* _tmp10_ = NULL;
				gint _tmp11_ = 0;
				gpointer _tmp12_ = NULL;
				gboolean _tmp13_ = FALSE;
				ElektroSimComponent* _tmp14_ = NULL;
				const gchar* _tmp15_ = NULL;
				const gchar* _tmp16_ = NULL;
				_tmp7_ = _component2_index;
				_component2_index = _tmp7_ + 1;
				_tmp8_ = _component2_index;
				_tmp9_ = _component2_size;
				if (!(_tmp8_ < _tmp9_)) {
					break;
				}
				_tmp10_ = _component2_list;
				_tmp11_ = _component2_index;
				_tmp12_ = gee_abstract_list_get ((GeeAbstractList*) _tmp10_, _tmp11_);
				component2 = (ElektroSimComponent*) _tmp12_;
				_tmp14_ = component2;
				_tmp15_ = gtk_widget_get_name ((GtkWidget*) _tmp14_);
				_tmp16_ = _tmp15_;
				if (g_strcmp0 (_tmp16_, "Line") == 0) {
					ElektroSimComponent* _tmp17_ = NULL;
					gboolean _tmp18_ = FALSE;
					gboolean _tmp19_ = FALSE;
					_tmp17_ = component2;
					_tmp18_ = elektro_sim_line_get_second_point_needed (G_TYPE_CHECK_INSTANCE_TYPE (_tmp17_, ELEKTRO_SIM_TYPE_LINE) ? ((ElektroSimLine*) _tmp17_) : NULL);
					_tmp19_ = _tmp18_;
					_tmp13_ = _tmp19_;
				} else {
					_tmp13_ = FALSE;
				}
				if (_tmp13_) {
					ElektroSimComponent* _tmp20_ = NULL;
					ElektroSimComponent* _tmp21_ = NULL;
					_tmp20_ = component2;
					_tmp21_ = _g_object_ref0 (_tmp20_);
					_g_object_unref0 (newComponent);
					newComponent = _tmp21_;
				}
				_g_object_unref0 (component2);
			}
			_g_object_unref0 (_component2_list);
		}
	}
	_tmp22_ = newComponent;
	if (_tmp22_ == NULL) {
		ElektroSimComponent* _tmp23_ = NULL;
		ElektroSimComponent* _tmp24_ = NULL;
		_tmp23_ = component;
		_tmp24_ = elektro_sim_component_clone (_tmp23_);
		_g_object_unref0 (newComponent);
		newComponent = _tmp24_;
	}
	_tmp25_ = newComponent;
	_tmp26_ = x;
	_tmp27_ = y;
	elektro_sim_component_snap (_tmp25_, 20, _tmp26_, _tmp27_);
	_tmp28_ = newComponent;
	g_signal_emit_by_name (self, "new-component", _tmp28_);
	elektro_sim_simulation_area_redraw_canvas (self);
	_g_object_unref0 (newComponent);
}


void elektro_sim_simulation_area_redraw_canvas (ElektroSimSimulationArea* self) {
	GdkWindow* window = NULL;
	GdkWindow* _tmp0_ = NULL;
	GdkWindow* _tmp1_ = NULL;
	GdkWindow* _tmp2_ = NULL;
	cairo_region_t* region = NULL;
	GdkWindow* _tmp3_ = NULL;
	cairo_region_t* _tmp4_ = NULL;
	GdkWindow* _tmp5_ = NULL;
	cairo_region_t* _tmp6_ = NULL;
	GdkWindow* _tmp7_ = NULL;
	g_return_if_fail (self != NULL);
	_tmp0_ = gtk_widget_get_window ((GtkWidget*) self);
	_tmp1_ = _g_object_ref0 (_tmp0_);
	window = _tmp1_;
	_tmp2_ = window;
	if (NULL == _tmp2_) {
		g_print ("no window");
		_g_object_unref0 (window);
		return;
	}
	_tmp3_ = window;
	_tmp4_ = gdk_window_get_clip_region (_tmp3_);
	region = _tmp4_;
	_tmp5_ = window;
	_tmp6_ = region;
	gdk_window_invalidate_region (_tmp5_, _tmp6_, TRUE);
	_tmp7_ = window;
	gdk_window_process_updates (_tmp7_, TRUE);
	_cairo_region_destroy0 (region);
	_g_object_unref0 (window);
}


static void g_cclosure_user_marshal_OBJECT__ENUM (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data) {
	typedef gpointer (*GMarshalFunc_OBJECT__ENUM) (gpointer data1, gint arg_1, gpointer data2);
	register GMarshalFunc_OBJECT__ENUM callback;
	register GCClosure * cc;
	register gpointer data1;
	register gpointer data2;
	gpointer v_return;
	cc = (GCClosure *) closure;
	g_return_if_fail (return_value != NULL);
	g_return_if_fail (n_param_values == 2);
	if (G_CCLOSURE_SWAP_DATA (closure)) {
		data1 = closure->data;
		data2 = param_values->data[0].v_pointer;
	} else {
		data1 = param_values->data[0].v_pointer;
		data2 = closure->data;
	}
	callback = (GMarshalFunc_OBJECT__ENUM) (marshal_data ? marshal_data : cc->callback);
	v_return = callback (data1, g_value_get_enum (param_values + 1), data2);
	g_value_take_object (return_value, v_return);
}


static void g_cclosure_user_marshal_OBJECT__VOID (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data) {
	typedef gpointer (*GMarshalFunc_OBJECT__VOID) (gpointer data1, gpointer data2);
	register GMarshalFunc_OBJECT__VOID callback;
	register GCClosure * cc;
	register gpointer data1;
	register gpointer data2;
	gpointer v_return;
	cc = (GCClosure *) closure;
	g_return_if_fail (return_value != NULL);
	g_return_if_fail (n_param_values == 1);
	if (G_CCLOSURE_SWAP_DATA (closure)) {
		data1 = closure->data;
		data2 = param_values->data[0].v_pointer;
	} else {
		data1 = param_values->data[0].v_pointer;
		data2 = closure->data;
	}
	callback = (GMarshalFunc_OBJECT__VOID) (marshal_data ? marshal_data : cc->callback);
	v_return = callback (data1, data2);
	g_value_take_object (return_value, v_return);
}


static void elektro_sim_simulation_area_class_init (ElektroSimSimulationAreaClass * klass) {
	elektro_sim_simulation_area_parent_class = g_type_class_peek_parent (klass);
	GTK_WIDGET_CLASS (klass)->draw = elektro_sim_simulation_area_real_draw;
	g_signal_new ("request_components", ELEKTRO_SIM_TYPE_SIMULATION_AREA, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_user_marshal_OBJECT__ENUM, GEE_TYPE_ARRAY_LIST, 1, ELEKTRO_SIM_COMPONENT_TYPE_COMPONENT_TYPE);
	g_signal_new ("new_component", ELEKTRO_SIM_TYPE_SIMULATION_AREA, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_marshal_VOID__OBJECT, G_TYPE_NONE, 1, ELEKTRO_SIM_TYPE_COMPONENT);
	g_signal_new ("request_selected_component", ELEKTRO_SIM_TYPE_SIMULATION_AREA, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_user_marshal_OBJECT__VOID, ELEKTRO_SIM_TYPE_COMPONENT, 0);
}


static void elektro_sim_simulation_area_instance_init (ElektroSimSimulationArea * self) {
}


GType elektro_sim_simulation_area_get_type (void) {
	static volatile gsize elektro_sim_simulation_area_type_id__volatile = 0;
	if (g_once_init_enter (&elektro_sim_simulation_area_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ElektroSimSimulationAreaClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) elektro_sim_simulation_area_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ElektroSimSimulationArea), 0, (GInstanceInitFunc) elektro_sim_simulation_area_instance_init, NULL };
		GType elektro_sim_simulation_area_type_id;
		elektro_sim_simulation_area_type_id = g_type_register_static (GTK_TYPE_DRAWING_AREA, "ElektroSimSimulationArea", &g_define_type_info, 0);
		g_once_init_leave (&elektro_sim_simulation_area_type_id__volatile, elektro_sim_simulation_area_type_id);
	}
	return elektro_sim_simulation_area_type_id__volatile;
}



