//
//  KZUnitSlider.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import "KZUnitSlider.h"

@interface KZUnitSlider()
@property (nonatomic, retain) UIImageView *sliderKnobView;
@end

@implementation KZUnitSlider
@synthesize sliderKnobView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        // Initialization code
        horizontal = frame.size.width > frame.size.height;
		
		UIImageView *knob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
		[self addSubview:knob];		
		self.sliderKnobView = knob;
		[knob release];
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		self.value = 0.0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [sliderKnobView release];
    [super dealloc];
}

- (CGFloat) value
{
	return value;
}

- (void) setValue:(CGFloat)val
{	
	value = MAX(MIN(val, 1.0), 0.0);
	
	CGFloat x = horizontal ? 
    roundf((1 - value) * (self.frame.size.width - 40) - self.sliderKnobView.bounds.size.width * 0.5) + self.sliderKnobView.bounds.size.width * 0.5:
    roundf((self.bounds.size.width - self.sliderKnobView.bounds.size.width) * 0.5) + self.sliderKnobView.bounds.size.width * 0.5;
    
	CGFloat y = horizontal ?
    roundf((self.bounds.size.height - self.sliderKnobView.bounds.size.height) * 0.5) + self.sliderKnobView.bounds.size.height * 0.5:
    roundf((1 - value) * (self.frame.size.height - 40) - self.sliderKnobView.bounds.size.height * 0.5) + self.sliderKnobView.bounds.size.height * 0.5;
	
    if(horizontal)
        x += 20;
    else
        y += 20;
    
	self.sliderKnobView.center = CGPointMake(x, y);
}

- (void) mapPointToValue:(CGPoint)point
{
	CGFloat val = horizontal ? 1 - ((point.x - 20) / (self.frame.size.width - 40)) : 1 - ((point.y - 20) / (self.frame.size.height - 40)); 
	self.value = val;
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToValue:[touch locationInView:self]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToValue:[touch locationInView:self]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self continueTrackingWithTouch:touch withEvent:event];
}

- (void)didAddSubview:(UIView *)subview
{
    [self bringSubviewToFront:sliderKnobView];
}
@end
