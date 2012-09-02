//
//  CMQGDefaultColorViewController.h
//  Quick Graph
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZColorPicker.h"

@protocol KZDefaultColorControllerDelegate;

@interface KZDefaultColorViewController : UIViewController 
{
    UIColor *selectedColor;
	id<KZDefaultColorControllerDelegate> delegate;
}
@property(nonatomic, assign) id<KZDefaultColorControllerDelegate> delegate;
@property(nonatomic, retain) UIColor *selectedColor;
@end

@protocol KZDefaultColorControllerDelegate
- (void) defaultColorController:(KZDefaultColorViewController *)controller didChangeColor:(UIColor *)color;
@end