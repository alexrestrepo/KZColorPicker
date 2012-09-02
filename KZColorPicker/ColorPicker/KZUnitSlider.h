//
//  KZUnitSlider.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KZUnitSlider : UIControl 
{
    UIImageView *sliderKnobView;
	
    BOOL horizontal;
	CGFloat value;
}

@property (nonatomic) CGFloat value;
@end
