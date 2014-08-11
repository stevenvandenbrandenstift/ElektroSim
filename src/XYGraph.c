/* XYGraph.c generated by valac 0.24.0, the Vala compiler
 * generated from XYGraph.vala, do not modify */

/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * Graph.vala
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
#include <gee.h>
#include <float.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <gdk/gdk.h>
#include <cairo.h>


#define ELEKTRO_SIM_TYPE_XY_GRAPH (elektro_sim_xy_graph_get_type ())
#define ELEKTRO_SIM_XY_GRAPH(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraph))
#define ELEKTRO_SIM_XY_GRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraphClass))
#define ELEKTRO_SIM_IS_XY_GRAPH(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH))
#define ELEKTRO_SIM_IS_XY_GRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_XY_GRAPH))
#define ELEKTRO_SIM_XY_GRAPH_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraphClass))

typedef struct _ElektroSimXYGraph ElektroSimXYGraph;
typedef struct _ElektroSimXYGraphClass ElektroSimXYGraphClass;
typedef struct _ElektroSimXYGraphPrivate ElektroSimXYGraphPrivate;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))
#define _cairo_region_destroy0(var) ((var == NULL) ? NULL : (var = (cairo_region_destroy (var), NULL)))

struct _ElektroSimXYGraph {
	GtkDrawingArea parent_instance;
	ElektroSimXYGraphPrivate * priv;
};

struct _ElektroSimXYGraphClass {
	GtkDrawingAreaClass parent_class;
};

struct _ElektroSimXYGraphPrivate {
	GeeArrayList* values;
	gdouble maxValue;
	gdouble minValue;
	GeeArrayList* time;
	gchar* name;
	gdouble rangeX;
	gdouble rangeY;
	gdouble offset;
	gint height;
	gint width;
};


static gpointer elektro_sim_xy_graph_parent_class = NULL;

GType elektro_sim_xy_graph_get_type (void) G_GNUC_CONST;
#define ELEKTRO_SIM_XY_GRAPH_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraphPrivate))
enum  {
	ELEKTRO_SIM_XY_GRAPH_DUMMY_PROPERTY
};
ElektroSimXYGraph* elektro_sim_xy_graph_new (void);
ElektroSimXYGraph* elektro_sim_xy_graph_construct (GType object_type);
static gboolean __lambda15_ (ElektroSimXYGraph* self);
void elektro_sim_xy_graph_set_values (ElektroSimXYGraph* self, GeeArrayList* values);
void elektro_sim_xy_graph_set_timepoints (ElektroSimXYGraph* self, GeeArrayList* timepoints);
static void elektro_sim_xy_graph_redraw_canvas (ElektroSimXYGraph* self);
static gboolean ___lambda15__gtk_widget_button_press_event (GtkWidget* _sender, GdkEventButton* event, gpointer self);
static void elektro_sim_xy_graph_draw_axes (ElektroSimXYGraph* self, cairo_t* cr, gdouble border, gdouble offset);
void elektro_sim_xy_graph_redraw (ElektroSimXYGraph* self);
static gboolean elektro_sim_xy_graph_real_draw (GtkWidget* base, cairo_t* cr);
static void elektro_sim_xy_graph_draw_label (ElektroSimXYGraph* self, cairo_t* cr, gint fontsize, const gchar* label, gdouble x, gdouble y);
void elektro_sim_debug (const gchar* line);
void elektro_sim_xy_graph_set_name (ElektroSimXYGraph* self, const gchar* name);
void elektro_sim_xy_graph_clear (ElektroSimXYGraph* self);
static void g_cclosure_user_marshal_OBJECT__BOOLEAN (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data);
static void g_cclosure_user_marshal_OBJECT__VOID (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data);
static void elektro_sim_xy_graph_finalize (GObject* obj);


static gboolean __lambda15_ (ElektroSimXYGraph* self) {
	gboolean result = FALSE;
	GeeArrayList* _tmp0_ = NULL;
	GeeArrayList* _tmp1_ = NULL;
	GeeArrayList* _tmp2_ = NULL;
	GeeArrayList* _tmp3_ = NULL;
	g_signal_emit_by_name (self, "request-selected-component-values", TRUE, &_tmp0_);
	_tmp1_ = _tmp0_;
	elektro_sim_xy_graph_set_values (self, _tmp1_);
	_g_object_unref0 (_tmp1_);
	g_signal_emit_by_name (self, "request-time-values", &_tmp2_);
	_tmp3_ = _tmp2_;
	elektro_sim_xy_graph_set_timepoints (self, _tmp3_);
	_g_object_unref0 (_tmp3_);
	elektro_sim_xy_graph_redraw_canvas (self);
	result = TRUE;
	return result;
}


static gboolean ___lambda15__gtk_widget_button_press_event (GtkWidget* _sender, GdkEventButton* event, gpointer self) {
	gboolean result;
	result = __lambda15_ ((ElektroSimXYGraph*) self);
	return result;
}


ElektroSimXYGraph* elektro_sim_xy_graph_construct (GType object_type) {
	ElektroSimXYGraph * self = NULL;
	gchar* _tmp0_ = NULL;
	self = (ElektroSimXYGraph*) g_object_new (object_type, NULL);
	gtk_widget_add_events ((GtkWidget*) self, (gint) GDK_BUTTON_PRESS_MASK);
	g_signal_connect_object ((GtkWidget*) self, "button-press-event", (GCallback) ___lambda15__gtk_widget_button_press_event, self, 0);
	gtk_widget_set_vexpand ((GtkWidget*) self, TRUE);
	gtk_widget_set_hexpand ((GtkWidget*) self, TRUE);
	_tmp0_ = g_strdup ("select a component and click here");
	_g_free0 (self->priv->name);
	self->priv->name = _tmp0_;
	elektro_sim_xy_graph_redraw_canvas (self);
	return self;
}


ElektroSimXYGraph* elektro_sim_xy_graph_new (void) {
	return elektro_sim_xy_graph_construct (ELEKTRO_SIM_TYPE_XY_GRAPH);
}


static void elektro_sim_xy_graph_draw_axes (ElektroSimXYGraph* self, cairo_t* cr, gdouble border, gdouble offset) {
	cairo_t* _tmp0_ = NULL;
	cairo_t* _tmp1_ = NULL;
	cairo_t* _tmp2_ = NULL;
	cairo_t* _tmp3_ = NULL;
	gdouble _tmp4_ = 0.0;
	gint _tmp5_ = 0;
	gdouble _tmp6_ = 0.0;
	gdouble _tmp7_ = 0.0;
	cairo_t* _tmp8_ = NULL;
	gint _tmp9_ = 0;
	gdouble _tmp10_ = 0.0;
	gint _tmp11_ = 0;
	gdouble _tmp12_ = 0.0;
	gdouble _tmp13_ = 0.0;
	cairo_t* _tmp14_ = NULL;
	cairo_t* _tmp15_ = NULL;
	gdouble _tmp16_ = 0.0;
	gdouble _tmp17_ = 0.0;
	gdouble _tmp18_ = 0.0;
	cairo_t* _tmp19_ = NULL;
	gdouble _tmp20_ = 0.0;
	gdouble _tmp21_ = 0.0;
	gint _tmp22_ = 0;
	gdouble _tmp23_ = 0.0;
	cairo_t* _tmp24_ = NULL;
	cairo_t* _tmp25_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (cr != NULL);
	_tmp0_ = cr;
	cairo_save (_tmp0_);
	_tmp1_ = cr;
	cairo_set_line_width (_tmp1_, (gdouble) 3);
	_tmp2_ = cr;
	cairo_set_source_rgb (_tmp2_, (gdouble) 0, (gdouble) 0, (gdouble) 0);
	_tmp3_ = cr;
	_tmp4_ = border;
	_tmp5_ = self->priv->height;
	_tmp6_ = border;
	_tmp7_ = offset;
	cairo_move_to (_tmp3_, _tmp4_, (_tmp5_ - _tmp6_) + _tmp7_);
	_tmp8_ = cr;
	_tmp9_ = self->priv->width;
	_tmp10_ = border;
	_tmp11_ = self->priv->height;
	_tmp12_ = border;
	_tmp13_ = offset;
	cairo_line_to (_tmp8_, _tmp9_ - (_tmp10_ / 2), (_tmp11_ - _tmp12_) + _tmp13_);
	_tmp14_ = cr;
	cairo_stroke (_tmp14_);
	_tmp15_ = cr;
	_tmp16_ = border;
	_tmp17_ = border;
	_tmp18_ = border;
	cairo_move_to (_tmp15_, _tmp16_ + (_tmp17_ / 2), _tmp18_ / 2);
	_tmp19_ = cr;
	_tmp20_ = border;
	_tmp21_ = border;
	_tmp22_ = self->priv->height;
	_tmp23_ = border;
	cairo_line_to (_tmp19_, _tmp20_ + (_tmp21_ / 2), _tmp22_ - (_tmp23_ / 2));
	_tmp24_ = cr;
	cairo_stroke (_tmp24_);
	_tmp25_ = cr;
	cairo_restore (_tmp25_);
}


void elektro_sim_xy_graph_redraw (ElektroSimXYGraph* self) {
	GeeArrayList* temp = NULL;
	GeeArrayList* _tmp0_ = NULL;
	GeeArrayList* _tmp1_ = NULL;
	GeeArrayList* _tmp3_ = NULL;
	GeeArrayList* _tmp4_ = NULL;
	g_return_if_fail (self != NULL);
	g_signal_emit_by_name (self, "request-selected-component-values", FALSE, &_tmp0_);
	temp = _tmp0_;
	_tmp1_ = temp;
	if (_tmp1_ != NULL) {
		GeeArrayList* _tmp2_ = NULL;
		_tmp2_ = temp;
		elektro_sim_xy_graph_set_values (self, _tmp2_);
	}
	g_signal_emit_by_name (self, "request-time-values", &_tmp3_);
	_tmp4_ = _tmp3_;
	elektro_sim_xy_graph_set_timepoints (self, _tmp4_);
	_g_object_unref0 (_tmp4_);
	elektro_sim_xy_graph_redraw_canvas (self);
	_g_object_unref0 (temp);
}


static gchar* double_to_string (gdouble self) {
	gchar* result = NULL;
	gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	gint _tmp1__length1 = 0;
	const gchar* _tmp2_ = NULL;
	gchar* _tmp3_ = NULL;
	gchar* _tmp4_ = NULL;
	_tmp0_ = g_new0 (gchar, G_ASCII_DTOSTR_BUF_SIZE);
	_tmp1_ = _tmp0_;
	_tmp1__length1 = G_ASCII_DTOSTR_BUF_SIZE;
	_tmp2_ = g_ascii_dtostr (_tmp1_, G_ASCII_DTOSTR_BUF_SIZE, self);
	_tmp3_ = g_strdup (_tmp2_);
	_tmp4_ = _tmp3_;
	_tmp1_ = (g_free (_tmp1_), NULL);
	result = _tmp4_;
	return result;
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


static gboolean elektro_sim_xy_graph_real_draw (GtkWidget* base, cairo_t* cr) {
	ElektroSimXYGraph * self;
	gboolean result = FALSE;
	cairo_t* _tmp0_ = NULL;
	cairo_t* _tmp1_ = NULL;
	cairo_t* _tmp2_ = NULL;
	cairo_t* _tmp3_ = NULL;
	cairo_t* _tmp4_ = NULL;
	cairo_t* _tmp5_ = NULL;
	gint border = 0;
	gint _tmp6_ = 0;
	gint _tmp7_ = 0;
	gint width_graph = 0;
	gint _tmp8_ = 0;
	gint _tmp9_ = 0;
	gint height_graph = 0;
	gint _tmp10_ = 0;
	gint _tmp11_ = 0;
	cairo_t* _tmp12_ = NULL;
	const gchar* _tmp13_ = NULL;
	gint _tmp14_ = 0;
	const gchar* _tmp15_ = NULL;
	gint _tmp16_ = 0;
	gint _tmp17_ = 0;
	gint _tmp18_ = 0;
	gboolean _tmp19_ = FALSE;
	gboolean _tmp20_ = FALSE;
	GeeArrayList* _tmp21_ = NULL;
	self = (ElektroSimXYGraph*) base;
	g_return_val_if_fail (cr != NULL, FALSE);
	_tmp0_ = cr;
	cairo_set_source_rgb (_tmp0_, 0.6, 0.6, 0.6);
	_tmp1_ = cr;
	cairo_fill (_tmp1_);
	_tmp2_ = cr;
	cairo_paint (_tmp2_);
	_tmp3_ = cr;
	cairo_set_source_rgb (_tmp3_, (gdouble) 200, (gdouble) 200, (gdouble) 200);
	_tmp4_ = cr;
	cairo_set_line_width (_tmp4_, (gdouble) 5);
	_tmp5_ = cr;
	cairo_select_font_face (_tmp5_, "Adventure", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
	border = 50;
	_tmp6_ = gtk_widget_get_allocated_width ((GtkWidget*) self);
	self->priv->width = _tmp6_;
	_tmp7_ = gtk_widget_get_allocated_height ((GtkWidget*) self);
	self->priv->height = _tmp7_;
	_tmp8_ = self->priv->width;
	_tmp9_ = border;
	width_graph = _tmp8_ - (2 * _tmp9_);
	_tmp10_ = self->priv->height;
	_tmp11_ = border;
	height_graph = _tmp10_ - (2 * _tmp11_);
	_tmp12_ = cr;
	_tmp13_ = self->priv->name;
	_tmp14_ = self->priv->width;
	_tmp15_ = self->priv->name;
	_tmp16_ = strlen (_tmp15_);
	_tmp17_ = _tmp16_;
	_tmp18_ = border;
	elektro_sim_xy_graph_draw_label (self, _tmp12_, 25, _tmp13_, (gdouble) ((_tmp14_ / 2) - _tmp17_), (gdouble) (_tmp18_ / 2));
	_tmp21_ = self->priv->time;
	if (_tmp21_ != NULL) {
		GeeArrayList* _tmp22_ = NULL;
		_tmp22_ = self->priv->values;
		_tmp20_ = _tmp22_ != NULL;
	} else {
		_tmp20_ = FALSE;
	}
	if (_tmp20_) {
		GeeArrayList* _tmp23_ = NULL;
		gint _tmp24_ = 0;
		gint _tmp25_ = 0;
		GeeArrayList* _tmp26_ = NULL;
		gint _tmp27_ = 0;
		gint _tmp28_ = 0;
		_tmp23_ = self->priv->values;
		_tmp24_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp23_);
		_tmp25_ = _tmp24_;
		_tmp26_ = self->priv->time;
		_tmp27_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp26_);
		_tmp28_ = _tmp27_;
		_tmp19_ = _tmp25_ >= _tmp28_;
	} else {
		_tmp19_ = FALSE;
	}
	if (_tmp19_) {
		gdouble scaleX = 0.0;
		gint _tmp29_ = 0;
		gdouble _tmp30_ = 0.0;
		gdouble scaleY = 0.0;
		gint _tmp31_ = 0;
		gdouble _tmp32_ = 0.0;
		gdouble _tmp33_ = 0.0;
		gchar* _tmp34_ = NULL;
		gchar* _tmp35_ = NULL;
		gchar* _tmp36_ = NULL;
		gchar* _tmp37_ = NULL;
		gchar* _tmp38_ = NULL;
		gchar* _tmp39_ = NULL;
		gdouble _tmp40_ = 0.0;
		gchar* _tmp41_ = NULL;
		gchar* _tmp42_ = NULL;
		gchar* _tmp43_ = NULL;
		gchar* _tmp44_ = NULL;
		gchar* _tmp45_ = NULL;
		gchar* _tmp46_ = NULL;
		gdouble _tmp47_ = 0.0;
		gchar* _tmp48_ = NULL;
		gchar* _tmp49_ = NULL;
		gchar* _tmp50_ = NULL;
		gchar* _tmp51_ = NULL;
		cairo_t* _tmp52_ = NULL;
		cairo_t* _tmp53_ = NULL;
		gint _tmp54_ = 0;
		gdouble _tmp55_ = 0.0;
		gdouble _tmp56_ = 0.0;
		cairo_t* _tmp57_ = NULL;
		gint _tmp58_ = 0;
		gint _tmp59_ = 0;
		gint _tmp60_ = 0;
		gint _tmp61_ = 0;
		gdouble _tmp62_ = 0.0;
		gdouble _tmp63_ = 0.0;
		gdouble _tmp64_ = 0.0;
		gchar* _tmp65_ = NULL;
		gchar* _tmp66_ = NULL;
		gchar* _tmp67_ = NULL;
		gchar* _tmp68_ = NULL;
		gchar* _tmp69_ = NULL;
		gchar* _tmp70_ = NULL;
		gdouble _tmp71_ = 0.0;
		gchar* _tmp72_ = NULL;
		gchar* _tmp73_ = NULL;
		gchar* _tmp74_ = NULL;
		gchar* _tmp75_ = NULL;
		cairo_t* _tmp76_ = NULL;
		gdouble _tmp77_ = 0.0;
		gchar* _tmp78_ = NULL;
		gchar* _tmp79_ = NULL;
		gdouble _tmp80_ = 0.0;
		gdouble _tmp81_ = 0.0;
		cairo_t* _tmp82_ = NULL;
		gdouble _tmp83_ = 0.0;
		gchar* _tmp84_ = NULL;
		gchar* _tmp85_ = NULL;
		gdouble _tmp86_ = 0.0;
		gdouble _tmp87_ = 0.0;
		cairo_t* _tmp88_ = NULL;
		cairo_t* _tmp89_ = NULL;
		gint counter = 0;
		cairo_t* _tmp119_ = NULL;
		_tmp29_ = width_graph;
		_tmp30_ = self->priv->rangeX;
		scaleX = _tmp29_ / _tmp30_;
		_tmp31_ = height_graph;
		_tmp32_ = self->priv->rangeY;
		scaleY = _tmp31_ / _tmp32_;
		_tmp33_ = self->priv->offset;
		_tmp34_ = double_to_string (_tmp33_);
		_tmp35_ = _tmp34_;
		_tmp36_ = g_strconcat ("offset: ", _tmp35_, NULL);
		_tmp37_ = _tmp36_;
		_tmp38_ = g_strconcat (_tmp37_, " scale: x: ", NULL);
		_tmp39_ = _tmp38_;
		_tmp40_ = scaleX;
		_tmp41_ = double_to_string (_tmp40_);
		_tmp42_ = _tmp41_;
		_tmp43_ = g_strconcat (_tmp39_, _tmp42_, NULL);
		_tmp44_ = _tmp43_;
		_tmp45_ = g_strconcat (_tmp44_, " y: ", NULL);
		_tmp46_ = _tmp45_;
		_tmp47_ = scaleY;
		_tmp48_ = double_to_string (_tmp47_);
		_tmp49_ = _tmp48_;
		_tmp50_ = g_strconcat (_tmp46_, _tmp49_, NULL);
		_tmp51_ = _tmp50_;
		elektro_sim_debug (_tmp51_);
		_g_free0 (_tmp51_);
		_g_free0 (_tmp49_);
		_g_free0 (_tmp46_);
		_g_free0 (_tmp44_);
		_g_free0 (_tmp42_);
		_g_free0 (_tmp39_);
		_g_free0 (_tmp37_);
		_g_free0 (_tmp35_);
		_tmp52_ = cr;
		cairo_set_source_rgb (_tmp52_, (gdouble) 22, (gdouble) 22, (gdouble) 22);
		_tmp53_ = cr;
		_tmp54_ = border;
		_tmp55_ = self->priv->offset;
		_tmp56_ = scaleY;
		elektro_sim_xy_graph_draw_axes (self, _tmp53_, (gdouble) _tmp54_, _tmp55_ * _tmp56_);
		_tmp57_ = cr;
		_tmp58_ = border;
		_tmp59_ = border;
		_tmp60_ = self->priv->height;
		_tmp61_ = border;
		_tmp62_ = self->priv->offset;
		_tmp63_ = scaleY;
		cairo_translate (_tmp57_, (gdouble) (_tmp58_ + (_tmp59_ / 2)), (_tmp60_ - _tmp61_) + (_tmp62_ * _tmp63_));
		_tmp64_ = self->priv->minValue;
		_tmp65_ = double_to_string (_tmp64_);
		_tmp66_ = _tmp65_;
		_tmp67_ = g_strconcat ("minValue ", _tmp66_, NULL);
		_tmp68_ = _tmp67_;
		_tmp69_ = g_strconcat (_tmp68_, " maxValue ", NULL);
		_tmp70_ = _tmp69_;
		_tmp71_ = self->priv->maxValue;
		_tmp72_ = double_to_string (_tmp71_);
		_tmp73_ = _tmp72_;
		_tmp74_ = g_strconcat (_tmp70_, _tmp73_, NULL);
		_tmp75_ = _tmp74_;
		elektro_sim_debug (_tmp75_);
		_g_free0 (_tmp75_);
		_g_free0 (_tmp73_);
		_g_free0 (_tmp70_);
		_g_free0 (_tmp68_);
		_g_free0 (_tmp66_);
		_tmp76_ = cr;
		_tmp77_ = self->priv->minValue;
		_tmp78_ = g_strdup_printf ("%f", _tmp77_);
		_tmp79_ = _tmp78_;
		_tmp80_ = self->priv->minValue;
		_tmp81_ = scaleY;
		elektro_sim_xy_graph_draw_label (self, _tmp76_, 10, _tmp79_, (gdouble) (-50), (-_tmp80_) * _tmp81_);
		_g_free0 (_tmp79_);
		_tmp82_ = cr;
		_tmp83_ = self->priv->maxValue;
		_tmp84_ = g_strdup_printf ("%f", _tmp83_);
		_tmp85_ = _tmp84_;
		_tmp86_ = self->priv->maxValue;
		_tmp87_ = scaleY;
		elektro_sim_xy_graph_draw_label (self, _tmp82_, 10, _tmp85_, (gdouble) (-50), (-_tmp86_) * _tmp87_);
		_g_free0 (_tmp85_);
		_tmp88_ = cr;
		cairo_set_source_rgb (_tmp88_, (gdouble) 22, (gdouble) 22, (gdouble) 22);
		_tmp89_ = cr;
		cairo_set_line_width (_tmp89_, (gdouble) 2);
		counter = 0;
		{
			GeeArrayList* _t_list = NULL;
			GeeArrayList* _tmp90_ = NULL;
			GeeArrayList* _tmp91_ = NULL;
			gint _t_size = 0;
			GeeArrayList* _tmp92_ = NULL;
			gint _tmp93_ = 0;
			gint _tmp94_ = 0;
			gint _t_index = 0;
			_tmp90_ = self->priv->time;
			_tmp91_ = _g_object_ref0 (_tmp90_);
			_t_list = _tmp91_;
			_tmp92_ = _t_list;
			_tmp93_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp92_);
			_tmp94_ = _tmp93_;
			_t_size = _tmp94_;
			_t_index = -1;
			while (TRUE) {
				gint _tmp95_ = 0;
				gint _tmp96_ = 0;
				gint _tmp97_ = 0;
				gdouble* t = NULL;
				GeeArrayList* _tmp98_ = NULL;
				gint _tmp99_ = 0;
				gpointer _tmp100_ = NULL;
				gint _tmp101_ = 0;
				gint _tmp118_ = 0;
				_tmp95_ = _t_index;
				_t_index = _tmp95_ + 1;
				_tmp96_ = _t_index;
				_tmp97_ = _t_size;
				if (!(_tmp96_ < _tmp97_)) {
					break;
				}
				_tmp98_ = _t_list;
				_tmp99_ = _t_index;
				_tmp100_ = gee_abstract_list_get ((GeeAbstractList*) _tmp98_, _tmp99_);
				t = (gdouble*) _tmp100_;
				_tmp101_ = counter;
				if (_tmp101_ == 0) {
					cairo_t* _tmp102_ = NULL;
					gdouble* _tmp103_ = NULL;
					gdouble _tmp104_ = 0.0;
					GeeArrayList* _tmp105_ = NULL;
					gint _tmp106_ = 0;
					gpointer _tmp107_ = NULL;
					gdouble* _tmp108_ = NULL;
					gdouble _tmp109_ = 0.0;
					_tmp102_ = cr;
					_tmp103_ = t;
					_tmp104_ = scaleX;
					_tmp105_ = self->priv->values;
					_tmp106_ = counter;
					_tmp107_ = gee_abstract_list_get ((GeeAbstractList*) _tmp105_, _tmp106_);
					_tmp108_ = (gdouble*) _tmp107_;
					_tmp109_ = scaleY;
					cairo_move_to (_tmp102_, (*_tmp103_) * _tmp104_, ((-1) * (*_tmp108_)) * _tmp109_);
					_g_free0 (_tmp108_);
				} else {
					cairo_t* _tmp110_ = NULL;
					gdouble* _tmp111_ = NULL;
					gdouble _tmp112_ = 0.0;
					GeeArrayList* _tmp113_ = NULL;
					gint _tmp114_ = 0;
					gpointer _tmp115_ = NULL;
					gdouble* _tmp116_ = NULL;
					gdouble _tmp117_ = 0.0;
					_tmp110_ = cr;
					_tmp111_ = t;
					_tmp112_ = scaleX;
					_tmp113_ = self->priv->values;
					_tmp114_ = counter;
					_tmp115_ = gee_abstract_list_get ((GeeAbstractList*) _tmp113_, _tmp114_);
					_tmp116_ = (gdouble*) _tmp115_;
					_tmp117_ = scaleY;
					cairo_line_to (_tmp110_, (*_tmp111_) * _tmp112_, ((-1) * (*_tmp116_)) * _tmp117_);
					_g_free0 (_tmp116_);
				}
				_tmp118_ = counter;
				counter = _tmp118_ + 1;
				_g_free0 (t);
			}
			_g_object_unref0 (_t_list);
		}
		_tmp119_ = cr;
		cairo_stroke (_tmp119_);
	}
	result = TRUE;
	return result;
}


static void elektro_sim_xy_graph_draw_label (ElektroSimXYGraph* self, cairo_t* cr, gint fontsize, const gchar* label, gdouble x, gdouble y) {
	cairo_t* _tmp0_ = NULL;
	cairo_t* _tmp1_ = NULL;
	gint _tmp2_ = 0;
	cairo_t* _tmp3_ = NULL;
	gdouble _tmp4_ = 0.0;
	const gchar* _tmp5_ = NULL;
	gint _tmp6_ = 0;
	gint _tmp7_ = 0;
	gdouble _tmp8_ = 0.0;
	cairo_t* _tmp9_ = NULL;
	const gchar* _tmp10_ = NULL;
	cairo_t* _tmp11_ = NULL;
	cairo_t* _tmp12_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (cr != NULL);
	g_return_if_fail (label != NULL);
	_tmp0_ = cr;
	cairo_save (_tmp0_);
	_tmp1_ = cr;
	_tmp2_ = fontsize;
	cairo_set_font_size (_tmp1_, (gdouble) _tmp2_);
	_tmp3_ = cr;
	_tmp4_ = x;
	_tmp5_ = label;
	_tmp6_ = strlen (_tmp5_);
	_tmp7_ = _tmp6_;
	_tmp8_ = y;
	cairo_move_to (_tmp3_, _tmp4_ - _tmp7_, _tmp8_);
	_tmp9_ = cr;
	_tmp10_ = label;
	cairo_text_path (_tmp9_, _tmp10_);
	_tmp11_ = cr;
	cairo_fill (_tmp11_);
	_tmp12_ = cr;
	cairo_restore (_tmp12_);
}


void elektro_sim_xy_graph_set_name (ElektroSimXYGraph* self, const gchar* name) {
	const gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	const gchar* _tmp2_ = NULL;
	gchar* _tmp3_ = NULL;
	gchar* _tmp4_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (name != NULL);
	_tmp0_ = name;
	_tmp1_ = g_strdup (_tmp0_);
	_g_free0 (self->priv->name);
	self->priv->name = _tmp1_;
	_tmp2_ = name;
	_tmp3_ = g_strconcat ("setname: ", _tmp2_, NULL);
	_tmp4_ = _tmp3_;
	elektro_sim_debug (_tmp4_);
	_g_free0 (_tmp4_);
}


void elektro_sim_xy_graph_set_timepoints (ElektroSimXYGraph* self, GeeArrayList* timepoints) {
	gboolean _tmp0_ = FALSE;
	GeeArrayList* _tmp1_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (timepoints != NULL);
	_tmp1_ = timepoints;
	if (_tmp1_ != NULL) {
		GeeArrayList* _tmp2_ = NULL;
		gint _tmp3_ = 0;
		gint _tmp4_ = 0;
		_tmp2_ = timepoints;
		_tmp3_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp2_);
		_tmp4_ = _tmp3_;
		_tmp0_ = _tmp4_ != 0;
	} else {
		_tmp0_ = FALSE;
	}
	if (_tmp0_) {
		GeeArrayList* _tmp5_ = NULL;
		GeeArrayList* _tmp6_ = NULL;
		GeeArrayList* _tmp7_ = NULL;
		GeeArrayList* _tmp8_ = NULL;
		gint _tmp9_ = 0;
		gint _tmp10_ = 0;
		gpointer _tmp11_ = NULL;
		gdouble* _tmp12_ = NULL;
		_tmp5_ = timepoints;
		_tmp6_ = _g_object_ref0 (_tmp5_);
		_g_object_unref0 (self->priv->time);
		self->priv->time = _tmp6_;
		_tmp7_ = timepoints;
		_tmp8_ = timepoints;
		_tmp9_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp8_);
		_tmp10_ = _tmp9_;
		_tmp11_ = gee_abstract_list_get ((GeeAbstractList*) _tmp7_, _tmp10_ - 1);
		_tmp12_ = (gdouble*) _tmp11_;
		self->priv->rangeX = *_tmp12_;
		_g_free0 (_tmp12_);
	}
}


void elektro_sim_xy_graph_set_values (ElektroSimXYGraph* self, GeeArrayList* values) {
	GeeArrayList* _tmp0_ = NULL;
	g_return_if_fail (self != NULL);
	g_return_if_fail (values != NULL);
	_tmp0_ = values;
	if (_tmp0_ != NULL) {
		GeeArrayList* _tmp1_ = NULL;
		GeeArrayList* _tmp2_ = NULL;
		gdouble _tmp3_ = 0.0;
		gboolean _tmp23_ = FALSE;
		gdouble _tmp24_ = 0.0;
		_tmp1_ = values;
		_tmp2_ = _g_object_ref0 (_tmp1_);
		_g_object_unref0 (self->priv->values);
		self->priv->values = _tmp2_;
		self->priv->offset = (gdouble) 0;
		_tmp3_ = DBL_MIN;
		self->priv->maxValue = _tmp3_;
		self->priv->minValue = (gdouble) 0;
		{
			GeeArrayList* _p_list = NULL;
			GeeArrayList* _tmp4_ = NULL;
			GeeArrayList* _tmp5_ = NULL;
			gint _p_size = 0;
			GeeArrayList* _tmp6_ = NULL;
			gint _tmp7_ = 0;
			gint _tmp8_ = 0;
			gint _p_index = 0;
			_tmp4_ = values;
			_tmp5_ = _g_object_ref0 (_tmp4_);
			_p_list = _tmp5_;
			_tmp6_ = _p_list;
			_tmp7_ = gee_abstract_collection_get_size ((GeeCollection*) _tmp6_);
			_tmp8_ = _tmp7_;
			_p_size = _tmp8_;
			_p_index = -1;
			while (TRUE) {
				gint _tmp9_ = 0;
				gint _tmp10_ = 0;
				gint _tmp11_ = 0;
				gdouble p = 0.0;
				GeeArrayList* _tmp12_ = NULL;
				gint _tmp13_ = 0;
				gpointer _tmp14_ = NULL;
				gdouble* _tmp15_ = NULL;
				gdouble _tmp16_ = 0.0;
				gdouble _tmp17_ = 0.0;
				gdouble _tmp18_ = 0.0;
				gdouble _tmp20_ = 0.0;
				gdouble _tmp21_ = 0.0;
				_tmp9_ = _p_index;
				_p_index = _tmp9_ + 1;
				_tmp10_ = _p_index;
				_tmp11_ = _p_size;
				if (!(_tmp10_ < _tmp11_)) {
					break;
				}
				_tmp12_ = _p_list;
				_tmp13_ = _p_index;
				_tmp14_ = gee_abstract_list_get ((GeeAbstractList*) _tmp12_, _tmp13_);
				_tmp15_ = (gdouble*) _tmp14_;
				_tmp16_ = *_tmp15_;
				_g_free0 (_tmp15_);
				p = _tmp16_;
				_tmp17_ = p;
				_tmp18_ = self->priv->maxValue;
				if (_tmp17_ > _tmp18_) {
					gdouble _tmp19_ = 0.0;
					_tmp19_ = p;
					self->priv->maxValue = _tmp19_;
				}
				_tmp20_ = p;
				_tmp21_ = self->priv->minValue;
				if (_tmp20_ < _tmp21_) {
					gdouble _tmp22_ = 0.0;
					_tmp22_ = p;
					self->priv->minValue = _tmp22_;
				}
			}
			_g_object_unref0 (_p_list);
		}
		_tmp24_ = self->priv->minValue;
		if (_tmp24_ <= ((gdouble) 0)) {
			gdouble _tmp25_ = 0.0;
			_tmp25_ = self->priv->maxValue;
			_tmp23_ = _tmp25_ >= ((gdouble) 0);
		} else {
			_tmp23_ = FALSE;
		}
		if (_tmp23_) {
			gdouble _tmp26_ = 0.0;
			gdouble _tmp27_ = 0.0;
			gdouble _tmp28_ = 0.0;
			_tmp26_ = self->priv->maxValue;
			_tmp27_ = self->priv->minValue;
			self->priv->rangeY = _tmp26_ - _tmp27_;
			_tmp28_ = self->priv->minValue;
			self->priv->offset = _tmp28_;
		} else {
			gboolean _tmp29_ = FALSE;
			gdouble _tmp30_ = 0.0;
			_tmp30_ = self->priv->minValue;
			if (_tmp30_ <= ((gdouble) 0)) {
				gdouble _tmp31_ = 0.0;
				_tmp31_ = self->priv->maxValue;
				_tmp29_ = _tmp31_ < ((gdouble) 0);
			} else {
				_tmp29_ = FALSE;
			}
			if (_tmp29_) {
				gdouble _tmp32_ = 0.0;
				gdouble _tmp33_ = 0.0;
				_tmp32_ = self->priv->minValue;
				self->priv->rangeY = -_tmp32_;
				_tmp33_ = self->priv->rangeY;
				self->priv->offset = _tmp33_;
			}
		}
	} else {
		elektro_sim_debug ("ERROR values=null");
	}
}


void elektro_sim_xy_graph_clear (ElektroSimXYGraph* self) {
	GeeArrayList* _tmp0_ = NULL;
	GeeArrayList* _tmp1_ = NULL;
	g_return_if_fail (self != NULL);
	_tmp0_ = self->priv->time;
	gee_abstract_collection_clear ((GeeAbstractCollection*) _tmp0_);
	_tmp1_ = self->priv->values;
	gee_abstract_collection_clear ((GeeAbstractCollection*) _tmp1_);
	elektro_sim_xy_graph_redraw_canvas (self);
}


static void elektro_sim_xy_graph_redraw_canvas (ElektroSimXYGraph* self) {
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


static void g_cclosure_user_marshal_OBJECT__BOOLEAN (GClosure * closure, GValue * return_value, guint n_param_values, const GValue * param_values, gpointer invocation_hint, gpointer marshal_data) {
	typedef gpointer (*GMarshalFunc_OBJECT__BOOLEAN) (gpointer data1, gboolean arg_1, gpointer data2);
	register GMarshalFunc_OBJECT__BOOLEAN callback;
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
	callback = (GMarshalFunc_OBJECT__BOOLEAN) (marshal_data ? marshal_data : cc->callback);
	v_return = callback (data1, g_value_get_boolean (param_values + 1), data2);
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


static void elektro_sim_xy_graph_class_init (ElektroSimXYGraphClass * klass) {
	elektro_sim_xy_graph_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (ElektroSimXYGraphPrivate));
	GTK_WIDGET_CLASS (klass)->draw = elektro_sim_xy_graph_real_draw;
	G_OBJECT_CLASS (klass)->finalize = elektro_sim_xy_graph_finalize;
	g_signal_new ("request_selected_component_values", ELEKTRO_SIM_TYPE_XY_GRAPH, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_user_marshal_OBJECT__BOOLEAN, GEE_TYPE_ARRAY_LIST, 1, G_TYPE_BOOLEAN);
	g_signal_new ("request_time_values", ELEKTRO_SIM_TYPE_XY_GRAPH, G_SIGNAL_RUN_LAST, 0, NULL, NULL, g_cclosure_user_marshal_OBJECT__VOID, GEE_TYPE_ARRAY_LIST, 0);
}


static void elektro_sim_xy_graph_instance_init (ElektroSimXYGraph * self) {
	self->priv = ELEKTRO_SIM_XY_GRAPH_GET_PRIVATE (self);
}


static void elektro_sim_xy_graph_finalize (GObject* obj) {
	ElektroSimXYGraph * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, ELEKTRO_SIM_TYPE_XY_GRAPH, ElektroSimXYGraph);
	_g_object_unref0 (self->priv->values);
	_g_object_unref0 (self->priv->time);
	_g_free0 (self->priv->name);
	G_OBJECT_CLASS (elektro_sim_xy_graph_parent_class)->finalize (obj);
}


GType elektro_sim_xy_graph_get_type (void) {
	static volatile gsize elektro_sim_xy_graph_type_id__volatile = 0;
	if (g_once_init_enter (&elektro_sim_xy_graph_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ElektroSimXYGraphClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) elektro_sim_xy_graph_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ElektroSimXYGraph), 0, (GInstanceInitFunc) elektro_sim_xy_graph_instance_init, NULL };
		GType elektro_sim_xy_graph_type_id;
		elektro_sim_xy_graph_type_id = g_type_register_static (GTK_TYPE_DRAWING_AREA, "ElektroSimXYGraph", &g_define_type_info, 0);
		g_once_init_leave (&elektro_sim_xy_graph_type_id__volatile, elektro_sim_xy_graph_type_id);
	}
	return elektro_sim_xy_graph_type_id__volatile;
}



