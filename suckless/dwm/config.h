/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 2;        /* gaps between windows (4 for surface, else 2) */
static const unsigned int gappx     = 6;        /* gaps between windows (10 for surface, else 6) */
static const unsigned int snap      = 24;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrains Mono:size=24" }; /* Use 24 for larger displays, else 12. */
static const char dmenufont[]       = "JetBrains Mono:size=24";
static const char col_gray1[]       = "#000000";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const unsigned int baralpha = 0x33;
static const unsigned int seethru = 0x00;
static const char *colors[][3]            = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray1 },
	[SchemeSel]  = { col_gray4, col_gray1, col_gray2 },
};
static const unsigned int alphas[][3]     = {
  /*               fg      bg        border*/
  [SchemeNorm] = { OPAQUE, seethru, seethru },
  [SchemeSel]  = { OPAQUE, seethru, seethru },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9"};

/* appicons */
/* NOTE: set to 0 to set to default (whitespace) */
static char outer_separator_beg      = '[';
static char outer_separator_end      = ']';
static char inner_separator          = ' ';
static unsigned truncate_icons_after = 2; /* will default to 1, that is the min */
static char truncate_symbol[]         = "⋯"; //⋯

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor    appicon */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1,        NULL },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1,        "󰈹" },
	{ "Brave",    NULL,       NULL,       1 << 8,       0,           -1,        NULL },
	{ "R_x11",    NULL,       NULL,       0,       	    1,           -1,        NULL },
	{ "Matplotlib",NULL,      NULL,       0,       	    1,           -1,        NULL },
	{ "org.gnome.Nautilus",NULL,NULL,     0,       	    1,           -1,        NULL },
	{ "Eclipse",  NULL,       NULL,       0,       	    1,           -1,        NULL },
	{ "Java",     NULL,       NULL,       0,       	    1,           -1,        NULL },
	{ "pavucontrol",NULL,     NULL,       0,            1,           -1,        NULL },
	{ "steam",        NULL,	  NULL,       0,       	    1,           -1,        NULL },
	{ "Virt-manager", NULL,	  NULL,       0,       	    1,           -1,        NULL },
	{ "feh", 	        NULL,	  NULL,       0,       	    1,           -1,        NULL },
	{ "zenity",       NULL,	  NULL,       0,       	    1,           -1,        NULL },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int attachbelow = 1;    /* 1 means attach after the currently active window */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]",      tile },    /* first entry is default */
	{ "<>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "alacritty", NULL }; /* Default terminal. Default is st. */

// Function that increments the tag
void
viewnext(const Arg *arg) {
    int i = selmon->tagset[selmon->seltags];
    i = (i << 1) | (i >> (LENGTH(tags) - 1));
    const Arg a = {.ui = i};
    view(&a);
}
// Function that decrements the tag
void 
viewprev(const Arg *arg) {
    int i = selmon->tagset[selmon->seltags];
    i = (i >> 1) | (i << (LENGTH(tags) - 1));
    const Arg a = {.ui = i};
    view(&a);
}

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,	                      XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_p,  	   setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_l,      spawn,          SHCMD("slock") },
	{ MODKEY|ShiftMask,             XK_b, 	   spawn,	         SHCMD("firefox") },
	{ MODKEY,                       XK_e,      spawn,	         SHCMD("nautilus-dark") },
	{ MODKEY|ShiftMask,             XK_s, 	   spawn,          SHCMD("maim -so | xclip -selection clipboard -t image/png") },
	{ MODKEY,                       XK_F1, 	   spawn,          SHCMD("brightnessctl set 5%-") },
	{ MODKEY,                       XK_F2,     spawn,          SHCMD("brightnessctl set +5%") },
	{ 0,                            XF86XK_AudioMute,spawn,	   SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle") },
	{ MODKEY,			                  XK_F10,    spawn,	   SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%") },
	{ MODKEY,			                  XK_F9, 	   spawn,	   SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%") },
	{ 0,				            XF86XK_AudioRaiseVolume,spawn,	   SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%") },
	{ 0,				            XF86XK_AudioLowerVolume,spawn,	   SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%") },
	{ 0,				              XF86XK_AudioPlay,      spawn,	   SHCMD("toggle-touchpad.sh") },
  { MODKEY,                       XK_x,      viewnext,      {0} },
  { MODKEY,                       XK_z,      viewprev,      {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};



