//
//  KZColorPickerAlphaSlider.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KZUnitSlider.h"

@interface KZColorPickerAlphaSlider : KZUnitSlider 
{
    CAGradientLayer *gradientLayer;
    UIView *checkerboard;
}

- (void) setKeyColor:(UIColor *)c;
@end
