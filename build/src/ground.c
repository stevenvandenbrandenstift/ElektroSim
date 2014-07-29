/* ground.c generated by valac 0.24.0, the Vala compiler
 * generated from ground.vala, do not modify */

/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * ground.vala
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
#include <cairo.h>
#include <stdlib.h>
#include <string.h>
#include <gee.h>
#include <float.h>
#include <math.h>


#define ELEKTRO_SIM_TYPE_COMPONENT (elektro_sim_component_get_type ())
#define ELEKTRO_SIM_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponent))
#define ELEKTRO_SIM_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))
#define ELEKTRO_SIM_IS_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_IS_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_COMPONENT))
#define ELEKTRO_SIM_COMPONENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_COMPONENT, ElektroSimComponentClass))

typedef struct _ElektroSimComponent ElektroSimComponent;
typedef struct _ElektroSimComponentClass ElektroSimComponentClass;
typedef struct _ElektroSimComponentPrivate ElektroSimComponentPrivate;

#define ELEKTRO_SIM_TYPE_PARAMETER (elektro_sim_parameter_get_type ())
#define ELEKTRO_SIM_PARAMETER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_PARAMETER, ElektroSimParameter))
#define ELEKTRO_SIM_PARAMETER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_PARAMETER, ElektroSimParameterClass))
#define ELEKTRO_SIM_IS_PARAMETER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_PARAMETER))
#define ELEKTRO_SIM_IS_PARAMETER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_PARAMETER))
#define ELEKTRO_SIM_PARAMETER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_PARAMETER, ElektroSimParameterClass))

typedef struct _ElektroSimParameter ElektroSimParameter;
typedef struct _ElektroSimParameterClass ElektroSimParameterClass;

#define ELEKTRO_SIM_TYPE_POINT (elektro_sim_point_get_type ())
#define ELEKTRO_SIM_POINT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_POINT, ElektroSimPoint))
#define ELEKTRO_SIM_POINT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_POINT, ElektroSimPointClass))
#define ELEKTRO_SIM_IS_POINT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_POINT))
#define ELEKTRO_SIM_IS_POINT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_POINT))
#define ELEKTRO_SIM_POINT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_POINT, ElektroSimPointClass))

typedef struct _ElektroSimPoint ElektroSimPoint;
typedef struct _ElektroSimPointClass ElektroSimPointClass;

#define ELEKTRO_SIM_TYPE_GROUND (elektro_sim_ground_get_type ())
#define ELEKTRO_SIM_GROUND(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), ELEKTRO_SIM_TYPE_GROUND, ElektroSimGround))
#define ELEKTRO_SIM_GROUND_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), ELEKTRO_SIM_TYPE_GROUND, ElektroSimGroundClass))
#define ELEKTRO_SIM_IS_GROUND(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), ELEKTRO_SIM_TYPE_GROUND))
#define ELEKTRO_SIM_IS_GROUND_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), ELEKTRO_SIM_TYPE_GROUND))
#define ELEKTRO_SIM_GROUND_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), ELEKTRO_SIM_TYPE_GROUND, ElektroSimGroundClass))

typedef struct _ElektroSimGround ElektroSimGround;
typedef struct _ElektroSimGroundClass ElektroSimGroundClass;
typedef struct _ElektroSimGroundPrivate ElektroSimGroundPrivate;
#define _elektro_sim_point_unref0(var) ((var == NULL) ? NULL : (var = (elektro_sim_point_unref (var), NULL)))

#define ELEKTRO_SIM_COMPONENT_TYPE_ORIENTATION (elektro_sim_component_orientation_get_type ())
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

struct _ElektroSimComponent {
	GtkListBoxRow parent_instance;
	ElektroSimComponentPrivate * priv;
	GeeArrayList* parameters;
	GeeArrayList* connections;
	cairo_surface_t* image_surface;
	cairo_t* image_context;
	cairo_surface_t* emoticon_surface;
	cairo_t* emoticon_context;
};

struct _ElektroSimComponentClass {
	GtkListBoxRowClass parent_class;
	ElektroSimComponent* (*clone) (ElektroSimComponent* self);
	void (*snap) (ElektroSimComponent* self, gint range, gint x, gint y);
	void (*draw_image) (ElektroSimComponent* self, cairo_t* cr);
	void (*clear_counter) (ElektroSimComponent* self);
	gchar* (*get_netlist_line) (ElektroSimComponent* self);
};

struct _ElektroSimGround {
	ElektroSimComponent parent_instance;
	ElektroSimGroundPrivate * priv;
};

struct _ElektroSimGroundClass {
	ElektroSimComponentClass parent_class;
};

typedef enum  {
	ELEKTRO_SIM_COMPONENT_ORIENTATION_NONE,
	ELEKTRO_SIM_COMPONENT_ORIENTATION_RIGHT,
	ELEKTRO_SIM_COMPONENT_ORIENTATION_LEFT,
	ELEKTRO_SIM_COMPONENT_ORIENTATION_DOWN,
	ELEKTRO_SIM_COMPONENT_ORIENTATION_UP
} ElektroSimComponentOrientation;


static gpointer elektro_sim_ground_parent_class = NULL;

GType elektro_sim_component_get_type (void) G_GNUC_CONST;
GType elektro_sim_parameter_get_type (void) G_GNUC_CONST;
gpointer elektro_sim_point_ref (gpointer instance);
void elektro_sim_point_unref (gpointer instance);
GParamSpec* elektro_sim_param_spec_point (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void elektro_sim_value_set_point (GValue* value, gpointer v_object);
void elektro_sim_value_take_point (GValue* value, gpointer v_object);
gpointer elektro_sim_value_get_point (const GValue* value);
GType elektro_sim_point_get_type (void) G_GNUC_CONST;
GType elektro_sim_ground_get_type (void) G_GNUC_CONST;
enum  {
	ELEKTRO_SIM_GROUND_DUMMY_PROPERTY
};
ElektroSimGround* elektro_sim_ground_new (void);
ElektroSimGround* elektro_sim_ground_construct (GType object_type);
ElektroSimComponent* elektro_sim_component_construct (GType object_type, const gchar* name);
void elektro_sim_component_clear_parameters (ElektroSimComponent* self);
void elektro_sim_component_set_width (ElektroSimComponent* self, gint value);
void elektro_sim_component_set_height (ElektroSimComponent* self, gint value);
static void elektro_sim_ground_real_draw_image (ElektroSimComponent* base, cairo_t* cr);
gint elektro_sim_point_get_x (ElektroSimPoint* self);
gint elektro_sim_point_get_y (ElektroSimPoint* self);
GType elektro_sim_component_orientation_get_type (void) G_GNUC_CONST;
ElektroSimComponentOrientation elektro_sim_component_get_orientation (ElektroSimComponent* self);
gint elektro_sim_component_get_width (ElektroSimComponent* self);
gint elektro_sim_component_get_height (ElektroSimComponent* self);
static ElektroSimComponent* elektro_sim_ground_real_clone (ElektroSimComponent* base);
static void elektro_sim_ground_real_snap (ElektroSimComponent* base, gint range, gint x, gint y);
ElektroSimPoint* elektro_sim_point_new (gint x, gint y);
ElektroSimPoint* elektro_sim_point_construct (GType object_type, gint x, gint y);
ElektroSimPoint* elektro_sim_point_point_nearby (ElektroSimPoint* self, gint range);
void elektro_sim_point_set_net (ElektroSimPoint* self, gint value);
ElektroSimComponentOrientation elektro_sim_point_connect_component (ElektroSimPoint* self, ElektroSimComponent* component);
void elektro_sim_component_set_orientation (ElektroSimComponent* self, ElektroSimComponentOrientation value);


ElektroSimGround* elektro_sim_ground_construct (GType object_type) {
	ElektroSimGround * self = NULL;
	self = (ElektroSimGround*) elektro_sim_component_construct (object_type, "Ground");
	elektro_sim_component_clear_parameters ((ElektroSimComponent*) self);
	elektro_sim_component_set_width ((ElektroSimComponent*) self, 100);
	elektro_sim_component_set_height ((ElektroSimComponent*) self, 50);
	return self;
}


ElektroSimGround* elektro_sim_ground_new (void) {
	return elektro_sim_ground_construct (ELEKTRO_SIM_TYPE_GROUND);
}


static void elektro_sim_ground_real_draw_image (ElektroSimComponent* base, cairo_t* cr) {
	ElektroSimGround * self;
	gint p1_x = 0;
	GeeArrayList* _tmp0_ = NULL;
	gpointer _tmp1_ = NULL;
	ElektroSimPoint* _tmp2_ = NULL;
	gint _tmp3_ = 0;
	gint _tmp4_ = 0;
	gint _tmp5_ = 0;
	gint p1_y = 0;
	GeeArrayList* _tmp6_ = NULL;
	gpointer _tmp7_ = NULL;
	ElektroSimPoint* _tmp8_ = NULL;
	gint _tmp9_ = 0;
	gint _tmp10_ = 0;
	gint _tmp11_ = 0;
	cairo_t* _tmp12_ = NULL;
	cairo_t* _tmp13_ = NULL;
	gint _tmp14_ = 0;
	gint _tmp15_ = 0;
	ElektroSimComponentOrientation _tmp16_ = 0;
	ElektroSimComponentOrientation _tmp17_ = 0;
	cairo_t* _tmp34_ = NULL;
	cairo_t* _tmp35_ = NULL;
	cairo_t* _tmp36_ = NULL;
	cairo_t* _tmp37_ = NULL;
	gint _tmp38_ = 0;
	gint _tmp39_ = 0;
	ElektroSimComponentOrientation _tmp40_ = 0;
	ElektroSimComponentOrientation _tmp41_ = 0;
	cairo_t* _tmp68_ = NULL;
	const gchar* _tmp69_ = NULL;
	const gchar* _tmp70_ = NULL;
	cairo_t* _tmp71_ = NULL;
	cairo_t* _tmp72_ = NULL;
	self = (ElektroSimGround*) base;
	g_return_if_fail (cr != NULL);
	_tmp0_ = ((ElektroSimComponent*) self)->connections;
	_tmp1_ = gee_abstract_list_get ((GeeAbstractList*) _tmp0_, 0);
	_tmp2_ = (ElektroSimPoint*) _tmp1_;
	_tmp3_ = elektro_sim_point_get_x (_tmp2_);
	_tmp4_ = _tmp3_;
	_tmp5_ = _tmp4_;
	_elektro_sim_point_unref0 (_tmp2_);
	p1_x = _tmp5_;
	_tmp6_ = ((ElektroSimComponent*) self)->connections;
	_tmp7_ = gee_abstract_list_get ((GeeAbstractList*) _tmp6_, 0);
	_tmp8_ = (ElektroSimPoint*) _tmp7_;
	_tmp9_ = elektro_sim_point_get_y (_tmp8_);
	_tmp10_ = _tmp9_;
	_tmp11_ = _tmp10_;
	_elektro_sim_point_unref0 (_tmp8_);
	p1_y = _tmp11_;
	_tmp12_ = cr;
	cairo_new_path (_tmp12_);
	_tmp13_ = cr;
	_tmp14_ = p1_x;
	_tmp15_ = p1_y;
	cairo_move_to (_tmp13_, (gdouble) _tmp14_, (gdouble) _tmp15_);
	_tmp16_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
	_tmp17_ = _tmp16_;
	if (_tmp17_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_RIGHT) {
		cairo_t* _tmp18_ = NULL;
		gint _tmp19_ = 0;
		gint _tmp20_ = 0;
		_tmp18_ = cr;
		_tmp19_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
		_tmp20_ = _tmp19_;
		cairo_rel_line_to (_tmp18_, (gdouble) _tmp20_, (gdouble) 0);
	} else {
		ElektroSimComponentOrientation _tmp21_ = 0;
		ElektroSimComponentOrientation _tmp22_ = 0;
		_tmp21_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
		_tmp22_ = _tmp21_;
		if (_tmp22_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_LEFT) {
			cairo_t* _tmp23_ = NULL;
			gint _tmp24_ = 0;
			gint _tmp25_ = 0;
			_tmp23_ = cr;
			_tmp24_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
			_tmp25_ = _tmp24_;
			cairo_rel_line_to (_tmp23_, (gdouble) (-_tmp25_), (gdouble) 0);
		} else {
			ElektroSimComponentOrientation _tmp26_ = 0;
			ElektroSimComponentOrientation _tmp27_ = 0;
			_tmp26_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
			_tmp27_ = _tmp26_;
			if (_tmp27_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_UP) {
				cairo_t* _tmp28_ = NULL;
				gint _tmp29_ = 0;
				gint _tmp30_ = 0;
				_tmp28_ = cr;
				_tmp29_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
				_tmp30_ = _tmp29_;
				cairo_rel_line_to (_tmp28_, (gdouble) 0, (gdouble) (-_tmp30_));
			} else {
				cairo_t* _tmp31_ = NULL;
				gint _tmp32_ = 0;
				gint _tmp33_ = 0;
				_tmp31_ = cr;
				_tmp32_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
				_tmp33_ = _tmp32_;
				cairo_rel_line_to (_tmp31_, (gdouble) 0, (gdouble) _tmp33_);
			}
		}
	}
	_tmp34_ = cr;
	cairo_close_path (_tmp34_);
	_tmp35_ = cr;
	cairo_stroke (_tmp35_);
	_tmp36_ = cr;
	cairo_new_path (_tmp36_);
	_tmp37_ = cr;
	_tmp38_ = elektro_sim_component_get_height ((ElektroSimComponent*) self);
	_tmp39_ = _tmp38_;
	cairo_set_font_size (_tmp37_, _tmp39_ * 0.4);
	_tmp40_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
	_tmp41_ = _tmp40_;
	if (_tmp41_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_RIGHT) {
		cairo_t* _tmp42_ = NULL;
		gint _tmp43_ = 0;
		gint _tmp44_ = 0;
		gint _tmp45_ = 0;
		gint _tmp46_ = 0;
		_tmp42_ = cr;
		_tmp43_ = p1_x;
		_tmp44_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
		_tmp45_ = _tmp44_;
		_tmp46_ = p1_y;
		cairo_move_to (_tmp42_, _tmp43_ + (_tmp45_ * 0.15), (gdouble) (_tmp46_ - 5));
	} else {
		ElektroSimComponentOrientation _tmp47_ = 0;
		ElektroSimComponentOrientation _tmp48_ = 0;
		_tmp47_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
		_tmp48_ = _tmp47_;
		if (_tmp48_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_LEFT) {
			cairo_t* _tmp49_ = NULL;
			gint _tmp50_ = 0;
			gint _tmp51_ = 0;
			gint _tmp52_ = 0;
			gint _tmp53_ = 0;
			_tmp49_ = cr;
			_tmp50_ = p1_x;
			_tmp51_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
			_tmp52_ = _tmp51_;
			_tmp53_ = p1_y;
			cairo_move_to (_tmp49_, (gdouble) (_tmp50_ - _tmp52_), (gdouble) (_tmp53_ - 5));
		} else {
			ElektroSimComponentOrientation _tmp54_ = 0;
			ElektroSimComponentOrientation _tmp55_ = 0;
			_tmp54_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
			_tmp55_ = _tmp54_;
			if (_tmp55_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_UP) {
				cairo_t* _tmp56_ = NULL;
				gint _tmp57_ = 0;
				gint _tmp58_ = 0;
				gint _tmp59_ = 0;
				gint _tmp60_ = 0;
				_tmp56_ = cr;
				_tmp57_ = p1_x;
				_tmp58_ = p1_y;
				_tmp59_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
				_tmp60_ = _tmp59_;
				cairo_move_to (_tmp56_, (gdouble) (_tmp57_ + 5), _tmp58_ - (_tmp60_ * 0.8));
			} else {
				ElektroSimComponentOrientation _tmp61_ = 0;
				ElektroSimComponentOrientation _tmp62_ = 0;
				_tmp61_ = elektro_sim_component_get_orientation ((ElektroSimComponent*) self);
				_tmp62_ = _tmp61_;
				if (_tmp62_ == ELEKTRO_SIM_COMPONENT_ORIENTATION_DOWN) {
					cairo_t* _tmp63_ = NULL;
					gint _tmp64_ = 0;
					gint _tmp65_ = 0;
					gint _tmp66_ = 0;
					gint _tmp67_ = 0;
					_tmp63_ = cr;
					_tmp64_ = p1_x;
					_tmp65_ = p1_y;
					_tmp66_ = elektro_sim_component_get_width ((ElektroSimComponent*) self);
					_tmp67_ = _tmp66_;
					cairo_move_to (_tmp63_, (gdouble) (_tmp64_ + 5), _tmp65_ + (_tmp67_ * 0.95));
				}
			}
		}
	}
	_tmp68_ = cr;
	_tmp69_ = gtk_widget_get_name ((GtkWidget*) self);
	_tmp70_ = _tmp69_;
	cairo_text_path (_tmp68_, _tmp70_);
	_tmp71_ = cr;
	cairo_fill (_tmp71_);
	_tmp72_ = cr;
	cairo_close_path (_tmp72_);
}


static ElektroSimComponent* elektro_sim_ground_real_clone (ElektroSimComponent* base) {
	ElektroSimGround * self;
	ElektroSimComponent* result = NULL;
	ElektroSimGround* newc = NULL;
	ElektroSimGround* _tmp0_ = NULL;
	self = (ElektroSimGround*) base;
	_tmp0_ = elektro_sim_ground_new ();
	g_object_ref_sink (_tmp0_);
	newc = _tmp0_;
	result = (ElektroSimComponent*) newc;
	return result;
}


static void elektro_sim_ground_real_snap (ElektroSimComponent* base, gint range, gint x, gint y) {
	ElektroSimGround * self;
	ElektroSimPoint* point = NULL;
	gint _tmp0_ = 0;
	gint _tmp1_ = 0;
	ElektroSimPoint* _tmp2_ = NULL;
	ElektroSimPoint* _tmp3_ = NULL;
	gint _tmp4_ = 0;
	ElektroSimPoint* _tmp5_ = NULL;
	ElektroSimPoint* _tmp6_ = NULL;
	ElektroSimPoint* _tmp7_ = NULL;
	ElektroSimComponentOrientation _tmp8_ = 0;
	GeeArrayList* _tmp9_ = NULL;
	ElektroSimPoint* _tmp10_ = NULL;
	self = (ElektroSimGround*) base;
	_tmp0_ = x;
	_tmp1_ = y;
	_tmp2_ = elektro_sim_point_new (_tmp0_, _tmp1_);
	_elektro_sim_point_unref0 (point);
	point = _tmp2_;
	_tmp3_ = point;
	_tmp4_ = range;
	_tmp5_ = elektro_sim_point_point_nearby (_tmp3_, _tmp4_);
	_elektro_sim_point_unref0 (point);
	point = _tmp5_;
	_tmp6_ = point;
	elektro_sim_point_set_net (_tmp6_, 0);
	_tmp7_ = point;
	_tmp8_ = elektro_sim_point_connect_component (_tmp7_, (ElektroSimComponent*) self);
	elektro_sim_component_set_orientation ((ElektroSimComponent*) self, _tmp8_);
	_tmp9_ = ((ElektroSimComponent*) self)->connections;
	_tmp10_ = point;
	gee_abstract_collection_add ((GeeAbstractCollection*) _tmp9_, _tmp10_);
	_elektro_sim_point_unref0 (point);
}


static void elektro_sim_ground_class_init (ElektroSimGroundClass * klass) {
	elektro_sim_ground_parent_class = g_type_class_peek_parent (klass);
	ELEKTRO_SIM_COMPONENT_CLASS (klass)->draw_image = elektro_sim_ground_real_draw_image;
	ELEKTRO_SIM_COMPONENT_CLASS (klass)->clone = elektro_sim_ground_real_clone;
	ELEKTRO_SIM_COMPONENT_CLASS (klass)->snap = elektro_sim_ground_real_snap;
}


static void elektro_sim_ground_instance_init (ElektroSimGround * self) {
}


GType elektro_sim_ground_get_type (void) {
	static volatile gsize elektro_sim_ground_type_id__volatile = 0;
	if (g_once_init_enter (&elektro_sim_ground_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (ElektroSimGroundClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) elektro_sim_ground_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (ElektroSimGround), 0, (GInstanceInitFunc) elektro_sim_ground_instance_init, NULL };
		GType elektro_sim_ground_type_id;
		elektro_sim_ground_type_id = g_type_register_static (ELEKTRO_SIM_TYPE_COMPONENT, "ElektroSimGround", &g_define_type_info, 0);
		g_once_init_leave (&elektro_sim_ground_type_id__volatile, elektro_sim_ground_type_id);
	}
	return elektro_sim_ground_type_id__volatile;
}



