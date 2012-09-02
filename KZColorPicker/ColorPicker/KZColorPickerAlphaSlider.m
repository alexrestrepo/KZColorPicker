//
//  KZColorPickerAlphaSlider.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import "KZColorPickerAlphaSlider.h"


@implementation KZColorPickerAlphaSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        checkerboard = [[UIView alloc] initWithFrame:CGRectMake(horizontal ? 18 : 6,
                                                                horizontal ? 6 : 18,
                                                                frame.size.width - (horizontal ? 36 : 12),
                                                                frame.size.height - (horizontal ? 12 : 36))];
        checkerboard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkerboard.png"]];
        checkerboard.layer.cornerRadius = 6.0;
        checkerboard.clipsToBounds = YES;
        checkerboard.userInteractionEnabled = NO;
        [self addSubview:checkerboard];
        [checkerboard release];
        
        gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.bounds = CGRectMake(horizontal ? 18 : 6,
                                          horizontal ? 6 : 18,
                                          frame.size.width - (horizontal ? 36 : 12),
                                          frame.size.height - (horizontal ? 12 : 36));
        
        gradientLayer.position = CGPointMake(checkerboard.bounds.size.width * 0.5, checkerboard.bounds.size.height * 0.5);
        
		gradientLayer.cornerRadius = 4.0;
		gradientLayer.borderWidth = 2.0;
		gradientLayer.borderColor = [[UIColor whiteColor] CGColor];
        
		if ([self respondsToSelector:@selector(contentScaleFactor)])
			self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        if (horizontal) 
        {
            gradientLayer.startPoint = CGPointMake(0.0, 0.5);
            gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        }
        
        [checkerboard.layer addSublayer:gradientLayer];
        [gradientLayer release];
		[self setKeyColor:[UIColor whiteColor]];
    }
    return self;
}

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
							 (id)[c colorWithAlphaComponent:0.0].CGColor,		 		 
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
    
    checkerboard.frame = gradientLayer.bounds;
    gradientLayer.position = CGPointMake(checkerboard.bounds.size.width * 0.5, checkerboard.bounds.size.height * 0.5);
    self.value = self.value;
}
@end
