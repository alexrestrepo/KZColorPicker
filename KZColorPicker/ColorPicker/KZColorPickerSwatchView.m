//
//  KZColorPickerSwatchView.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KZColorPickerSwatchView.h"

@interface KZColorPickerSwatchView ()
@property (nonatomic, assign) CAShapeLayer *touchDownLayer;
@property (nonatomic, assign) CALayer *checkmarkLayer;
@property (nonatomic, retain) UIColor *checkerboardColor;
+ (CGPathRef)newRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
@end

static CGFloat kCheckmarkWidth = 22;

#pragma mark - Properties
@implementation KZColorPickerSwatchView
@synthesize color = _color;
@synthesize checkerboardColor = _checkerboardColor;
@synthesize borderWidth = _borderWidth;
@synthesize touchDownLayer =_touchDownLayer;
@synthesize checkmarkLayer =_checkmarkLayer;
@synthesize cornerRadius = _cornerRadius;
@synthesize hasShadow = _hasShadow;

#pragma mark - Init / Dealloc
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (!self) 
        return nil;
    
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    self.color = [[UIColor blueColor] colorWithAlphaComponent:0.5];//[UIColor whiteColor];//
    self.borderWidth = 1.0;
    
    self.touchDownLayer = [CAShapeLayer layer];
    self.touchDownLayer.opacity = 0.0f;
    [self.layer addSublayer:self.touchDownLayer];
    
    self.checkmarkLayer = [CALayer layer];
    self.checkmarkLayer.hidden = YES;
    self.checkmarkLayer.contents = (id)[UIImage imageNamed:@"MNColorViewCheckmark.png"].CGImage;
    self.checkmarkLayer.bounds = CGRectMake(0, 0, kCheckmarkWidth, kCheckmarkWidth);
    [self.layer addSublayer:self.checkmarkLayer];
    
    self.cornerRadius = 6.0f;
    self.hasShadow = YES;
    
    return self;
}

- (void)dealloc 
{
    [_color release];
    [_checkerboardColor release];
    [super dealloc];
}

#pragma mark - Custom Properties

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.checkmarkLayer.hidden = !selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (animated) 
    {
        [self setSelected:selected];
    } 
    else 
    {
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.000f] forKey:kCATransactionAnimationDuration];
        [self setSelected:selected];
        [CATransaction commit];
    }
}

- (void) setColor:(UIColor *)color
{
    [color retain];
    [_color release];
    _color = color;
    
    [self setNeedsDisplay];
}

- (UIColor *)checkerboardColor
{
    if(!_checkerboardColor)
    {
        self.checkerboardColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkerboard.png"]];
    }
    
    return _checkerboardColor;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();                    
    // does color have alpha???
    if(CGColorGetAlpha(self.color.CGColor) < 1.0)
    {
        CGPathRef checkerPath = [[self class] newRoundRectPathForBoundingRect:CGRectInset(self.bounds, self.borderWidth, self.borderWidth) cornerRadius:self.cornerRadius - 1.0f];
        CGContextAddPath(context, checkerPath);    
        [self.checkerboardColor setFill];    
        CGContextFillPath(context);
        CGPathRelease(checkerPath);
    }
    
    CGPathRef fillPath = [[self class] newRoundRectPathForBoundingRect:self.bounds cornerRadius:self.cornerRadius + 1.0f];
    CGContextAddPath(context, fillPath);
    [self.color setFill];    
    CGContextFillPath(context);
    CGPathRelease(fillPath);
    
    
    CGContextSetLineWidth(context, self.borderWidth);
    CGPathRef borderPath = [[self class] newRoundRectPathForBoundingRect:CGRectInset(self.bounds, self.borderWidth * 0.5, self.borderWidth * 0.5) cornerRadius:self.cornerRadius];
        
    CGContextAddPath(context, borderPath);
    
    if(_hasShadow)
    {
        [[UIColor colorWithWhite:0.6 alpha:1.0] setStroke];
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        CGContextSetShadowWithColor(context, CGSizeMake(0, /*self.borderWidth*/ 1.0f), 0,[UIColor colorWithWhite:1.0 alpha:0.8].CGColor);         
    }
    else
    {
        [[UIColor whiteColor] setStroke];
    }
    
    CGContextStrokePath(context);            
    CGPathRelease(borderPath);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGPathRef path = [[self class] newRoundRectPathForBoundingRect:self.bounds cornerRadius:self.cornerRadius];
    self.touchDownLayer.path = path;
    CGPathRelease(path);    
    
    CGRect frame = self.bounds;
    self.checkmarkLayer.position = CGPointMake(CGRectGetMaxX(frame) - kCheckmarkWidth / 2 - 3, CGRectGetMaxY(frame) - kCheckmarkWidth / 2 - 3);    
}

#pragma mark - Touch Handling

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL flag = [super beginTrackingWithTouch:touch withEvent:event];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.001f] forKey:kCATransactionAnimationDuration];
    self.touchDownLayer.opacity = 0.2f;
    [CATransaction commit];
    
    return flag;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchDownLayer.opacity = 0.0;
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.touchDownLayer.opacity = 0.0;
    [super cancelTrackingWithEvent:event];
}

+ (CGPathRef)newRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    // Drawing code in parts from http://stackoverflow.com/questions/400965/how-to-customize-the-background-border-colors-of-a-grouped-table-view
    // rect = CGRectInset(rect, 0.5, 0.5);
    const NSUInteger inset = 1.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + inset;
    miny = miny + inset;
    
    maxx = maxx - inset;
    maxy = maxy - inset;
    
    CGPathMoveToPoint(path, NULL, minx, midy);
    CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, cornerRadius);
    CGPathCloseSubpath(path);
    return path;
}
@end
