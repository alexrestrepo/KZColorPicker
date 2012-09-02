//
//  KZQGColorSwatchView.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZColorPickerSwatchView : UIControl 
{
    
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) BOOL hasShadow;
@end
