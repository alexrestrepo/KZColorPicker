/*
 *  HSV.c
 *  colorPickerTest
 *
 *  Created by Alex Restrepo on 4/26/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include <math.h>
#include "HSV.h"

inline RGBType RGBTypeMake(float r, float g, float b)
{
	RGBType rgb = {r, g, b};
	return rgb;
}

inline HSVType HSVTypeMake(float h, float s, float v)
{
	HSVType hsv = {h, s, v};
	return hsv;
}

HSVType RGB_to_HSV( RGBType RGB )
{
    // RGB are each on [0, 1]. S and V are returned on [0, 1] and H is
    // returned on [0, 1]. Exception: H is returned UNDEFINED if S==0.
    float R = RGB.r, G = RGB.g, B = RGB.b, v, x, f;
    int i;
	
    x = fminf(R, G);
    x = fminf(x, B);
	
    v = fmaxf(R, G);
    v = fmaxf(v, B);
	
    if(v == x) 
		return HSVTypeMake(UNDEFINED, 0, v);
	
    f = (R == x) ? G - B : ((G == x) ? B - R : R - G);
    i = (R == x) ? 3 : ((G == x) ? 5 : 1);
	
    return HSVTypeMake(((i - f /(v - x))/6), (v - x)/v, v);
}

RGBType HSV_to_RGB( HSVType HSV )
{
    // H is given on [0, 1] or UNDEFINED. S and V are given on [0, 1].
    // RGB are each returned on [0, 1].
    float h = HSV.h * 6, s = HSV.s, v = HSV.v, m, n, f;
    int i;

    if (h == 0) h=.01;
    if(h == UNDEFINED) 
		return RGBTypeMake(v, v, v);
    i = floorf(h);
    f = h - i;
    if(!(i & 1)) f = 1 - f; // if i is even
    m = v * (1 - s);
    n = v * (1 - s * f);
    switch (i)
	{
        case 6:
        case 0: return RGBTypeMake(v, n, m);
        case 1: return RGBTypeMake(n, v, m);
        case 2: return RGBTypeMake(m, v, n);
        case 3: return RGBTypeMake(m, n, v);
        case 4: return RGBTypeMake(n, m, v);
        case 5: return RGBTypeMake(v, m, n);
	}
    return RGBTypeMake(0, 0, 0);
}