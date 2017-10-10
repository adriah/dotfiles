/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[] = "-*-xbmicons-medium-r-*-*-17-120-100-100-c-*-*-*"","
                           "-*-terminus-medium-r-*-*-17-*-*-*-*-*-*-*";
#define NUMCOLORS 12
static const char colors[NUMCOLORS][ColLast][9] = {
  // border foreground background
  { "#181818", "#81a2be", "#181818" }, // 1 = normal #373b41 (grey on black)
  { "#c0c0c0", "#c5c8c6", "#181818" }, // 2 = selected (white on black)
  { "#dc322f", "#181818", "#f0c674" }, // 3 = urgent (black on yellow)
  { "#181818", "#181818", "#181818" }, // 4 = darkgrey on black (for glyphs)
  { "#181818", "#181818", "#181818" }, // 5 = black on darkgrey (for glyphs)
  { "#181818", "#cc6666", "#181818" }, // 6 = red on black
  { "#181818", "#b5bd68", "#181818" }, // 7 = green on black
  { "#181818", "#de935f", "#181818" }, // 8 = orange on black
  { "#181818", "#f0c674", "#181818" }, // 9 = yellow on darkgrey
  { "#181818", "#81a2be", "#181818" }, // A = blue on darkgrey
  { "#181818", "#b294bb", "#181818" }, // B = magenta on darkgrey
  { "#181818", "#8abeb7", "#181818" }, // C = cyan on darkgrey
  { "#c0c0c0", "#c0c0c0", "#181818" }, // D = white #c5c8c6 on darkgrey
};
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 8;        /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */
static const unsigned int gappx     = 6;

/* tagging */
static const char *tags[] = { "+", "+", "+", "+", "+"};

static const Rule rules[] = {
  /* class                      instance     title  tags mask isfloating  iscentred   monitor */
  { "feh",                      NULL,        NULL,  0,        True,       True,       -1 },
  { "Gcolor2",                  NULL,        NULL,  0,        True,       True,       -1 },
  { "XFontSel",                 NULL,        NULL,  0,        True,       True,       -1 },
  { "Xfd",                      NULL,        NULL,  0,        True,       True,       -1 },
  { "Gimp",                     NULL,        NULL,  1 << 5,   True,       True,       -1 },
  { "Pavucontrol",              NULL,        NULL,  1 << 5,   True,       True,       -1 },
  { "Nvidia-settings",          NULL,        NULL,  1 << 5,   True,       True,       -1 },
  { "Spotify",                  NULL,        NULL,  1 << 5,   True,       True,       -1 },

};

/* layout(s) */
static const float mfact      = 0.50;  /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;     /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */


#include "bstack.c"
#include "gaplessgrid.c"
static const Layout layouts[] = {
  /* symbol     arrange function */
  { "\uE019 \uE009 \uE019",    tile },    /* first entry is default */
  { "\uE019 \uE00A \uE019",    NULL },    /* no layout function means floating behavior */
  { "\uE019 \uE00B \uE019",    monocle },
  { "\uE019 \uE00C \uE019",    bstack },
  { "\uE019 \uE00D \uE019",    gaplessgrid },
  { "\uE019 \uE021 \uE019",    spiral },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,     {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,           {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char  *dmenucmd[]     = { "dmenu_run", "-fn", font, "-nb", colors[0][ColBG], "-nf", colors[0][ColFG], "-sb", colors[1][ColBG], "-sf", colors[1][ColFG], NULL };
static const char *termcmd[]       = { "urxvt", NULL };

#include "push.c"
static Key keys[] = {
  /* modifier               key               function        argument */
  { MODKEY,                 XK_p,             spawn,          {.v = dmenucmd } },
  { MODKEY|ShiftMask,       XK_Return,        spawn,          {.v = termcmd } },
  { MODKEY|ControlMask,     XK_b,             togglebar,      {0} },
  { MODKEY,                 XK_j,             focusstack,     {.i = +1 } },
  { MODKEY,                 XK_k,             focusstack,     {.i = -1 } },
  { MODKEY|ShiftMask,       XK_j,             pushdown,       {0} },
  { MODKEY|ShiftMask,       XK_k,             pushup,         {0} },
  { MODKEY,                 XK_i,             incnmaster,     {.i = +1 } },
  { MODKEY,                 XK_d,             incnmaster,     {.i = -1 } },
  { MODKEY,                 XK_h,             setmfact,       {.f = -0.05} },
  { MODKEY,                 XK_l,             setmfact,       {.f = +0.05} },
  { MODKEY,                 XK_Return,        zoom,           {0} },
  { MODKEY,                 XK_Tab,           view,           {0} },
  { MODKEY|ShiftMask,       XK_c,             killclient,     {0} },
  { MODKEY,                 XK_t,             setlayout,      {.v = &layouts[0]} },
  { MODKEY,                 XK_f,             setlayout,      {.v = &layouts[1]} },
  { MODKEY,                 XK_m,             setlayout,      {.v = &layouts[2]} },
  { MODKEY,                 XK_b,             setlayout,      {.v = &layouts[3]} },
  { MODKEY,                 XK_g,             setlayout,      {.v = &layouts[4]} },
  { MODKEY,		    XK_s, 	      setlayout,      {.v = &layouts[5]} },
  { MODKEY,                 XK_space,         setlayout,      {0} },
  { MODKEY|ShiftMask,       XK_space,         togglefloating, {0} },
  { MODKEY,                 XK_0,             view,           {.ui = ~0 } },
  { MODKEY|ShiftMask,       XK_0,             tag,            {.ui = ~0 } },
  { MODKEY,                 XK_comma,         focusmon,       {.i = -1 } },
  { MODKEY,                 XK_period,        focusmon,       {.i = +1 } },
  { MODKEY|ShiftMask,       XK_comma,         tagmon,         {.i = -1 } },
  { MODKEY|ShiftMask,       XK_period,        tagmon,         {.i = +1 } },
  TAGKEYS(                  XK_1,                             0)
    TAGKEYS(                  XK_2,                             1)
    TAGKEYS(                  XK_3,                             2)
    TAGKEYS(                  XK_4,                             3)
    TAGKEYS(                  XK_5,                             4)
    TAGKEYS(                  XK_6,                             5)
    TAGKEYS(                  XK_7,                             6)
    TAGKEYS(                  XK_8,                             7)
    TAGKEYS(                  XK_9,                             8)
    { MODKEY|ShiftMask,       XK_q,             quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
  /* click                event mask      button          function        argument */
  { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
  { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
  { ClkWinTitle,          0,              Button2,        zoom,           {0} },
  { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
  { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
  { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
  { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
  { ClkTagBar,            0,              Button1,        toggleview,     {0} },
  { ClkTagBar,            0,              Button3,        view,           {0} },
  { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
  { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

