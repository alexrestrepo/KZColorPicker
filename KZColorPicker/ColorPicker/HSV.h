/*
 *  HSV.h
 *  colorPickerTest
 *
 *  Created by Alex Restrepo on 4/26/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */



//code from http://www.cocoabuilder.com/archive/cocoa/198570-here-is-code-to-convert-rgb-hsb.html
#define UNDEFINED 0

typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;

// Theoretically, hue 0 (pure red) is identical to hue 6 in these transforms. Pure
// red always maps to 6 in this implementation. Therefore UNDEFINED can be
// defined as 0 in situations where only unsigned numbers are desired.
RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);

HSVType RGB_to_HSV( RGBType RGB );
RGBType HSV_to_RGB( HSVType HSV );