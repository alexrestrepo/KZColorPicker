//
//  KZColorPickerBrightnessSlider.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import "KZColorPickerBrightnessSlider.h"

@implementation KZColorPickerBrightnessSlider

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{		
        // Initialization code
        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.bounds = CGRectMake(horizontal ? 18 : 6,
                                          horizontal ? 6 : 18,
                                          frame.size.width - (horizontal ? 36 : 12),
                                          frame.size.height - (horizontal ? 12 : 36));
        
        gradientLayer.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
		gradientLayer.cornerRadius = 6.0;
		gradientLayer.borderWidth = 2.0;
		gradientLayer.borderColor = [[UIColor whiteColor] CGColor];
                
		if ([self respondsToSelector:@selector(contentScaleFactor)])
			self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        [self.layer insertSublayer:gradientLayer atIndex:0];
        [gradientLayer release];
		[self setKeyColor:[UIColor whiteColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc 
{
    [super dealloc];
}

- (void) setKeyColor:(UIColor *)c
{	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	gradientLayer.colors =  [NSArray arrayWithObjects:	 
							 (id)c.CGColor,
							 (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.000].CGColor,		 		 
							 nil];
	[CATransaction commit];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    gradientLayer.bounds = CGRectMake(horizontal ? 18 : 6,
                                      horizontal ? 6 : 18,
                                      frame.size.width - (horizontal ? 36 : 12),
                                      frame.size.height - (horizontal ? 12 : 36));
    
    gradientLayer.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    self.value = self.value;
}
@end
