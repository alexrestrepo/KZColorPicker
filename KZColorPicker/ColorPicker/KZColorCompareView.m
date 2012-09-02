//
//  KZColorCompareView.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KZColorCompareView.h"

@interface KZColorCompareView ()
@property (nonatomic, assign) CAShapeLayer *touchDownLayer;
@property (nonatomic, retain) UIColor *checkerboardColor;
+ (CGPathRef)newRightRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (CGPathRef)newLeftRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (CGPathRef)newRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
@end

@implementation KZColorCompareView
#pragma mark - Properties
@synthesize oldColor = _oldColor;
@synthesize currentColor = _currentColor;
@synthesize touchDownLayer = _touchDownLayer;
@synthesize checkerboardColor = _checkerboardColor;

#pragma mark - Init/Dealloc
- (void)dealloc 
{
    [_oldColor release];
    [_currentColor release];
    [_checkerboardColor release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (!self) 
        return nil;
    
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    self.oldColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];//[UIColor whiteColor];//
    self.currentColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];//[UIColor whiteColor];//
    
    self.touchDownLayer = [CAShapeLayer layer];
    self.touchDownLayer.opacity = 0.0f;
    [self.layer addSublayer:self.touchDownLayer];
            
    return self;
}

#pragma mark - Custom Properties
- (void) setOldColor:(UIColor *)color
{
    [color retain];
    [_oldColor release];
    _oldColor = color;
    
    [self setNeedsDisplay];
}

- (void) setCurrentColor:(UIColor *)color
{
    [color retain];
    [_currentColor release];
    _currentColor = color;
    
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
    const CGFloat cornerRadius = 6.0f;
    const CGFloat borderWidth = 2.0f;
    CGContextRef context = UIGraphicsGetCurrentContext();                    
    
    // does color have alpha???
    if(CGColorGetAlpha(self.oldColor.CGColor) < 1.0 || CGColorGetAlpha(self.currentColor.CGColor))
    {
        CGPathRef checkerPath = [[self class] newRoundRectPathForBoundingRect:CGRectInset(self.bounds, borderWidth, borderWidth) cornerRadius:cornerRadius - 1.0f];
        CGContextAddPath(context, checkerPath);    
        [self.checkerboardColor setFill];    
        CGContextFillPath(context);
        CGPathRelease(checkerPath);
    }
    
    CGPathRef leftFillPath = [[self class] newLeftRoundRectPathForBoundingRect:CGRectMake(0, 0, self.bounds.size.width * 0.5 + 1.0f, self.bounds.size.height) cornerRadius:cornerRadius + 1.0f];
    CGContextAddPath(context, leftFillPath);
    [self.oldColor setFill];    
    CGContextFillPath(context);
    CGPathRelease(leftFillPath);
    
    CGPathRef rightFillPath = [[self class] newRightRoundRectPathForBoundingRect:CGRectMake(self.bounds.size.width * 0.5 - 1.0f, 0, self.bounds.size.width * 0.5 + 1.0f, self.bounds.size.height) cornerRadius:cornerRadius + 1.0f];
    CGContextAddPath(context, rightFillPath);
    [self.currentColor setFill];    
    CGContextFillPath(context);
    CGPathRelease(rightFillPath);
    
    CGContextSetLineWidth(context, borderWidth);
    CGPathRef borderPath = [[self class] newRoundRectPathForBoundingRect:CGRectInset(self.bounds, borderWidth * 0.5, borderWidth * 0.5) cornerRadius:cornerRadius];
    [[UIColor whiteColor] setStroke];    
    CGContextAddPath(context, borderPath);
    CGContextStrokePath(context);            
    CGPathRelease(borderPath);    
    
    /*
    // does color have alpha???
    if(CGColorGetAlpha(self.color.CGColor) < 1.0)
    {
        CGPathRef checkerPath = [[self class] createRoundRectPathForBoundingRect:CGRectInset(self.bounds, self.borderWidth, self.borderWidth) cornerRadius:self.cornerRadius];
        CGContextAddPath(context, checkerPath);    
        [self.checkerboardColor setFill];    
        CGContextFillPath(context);
        CGPathRelease(checkerPath);
    }
    
    CGPathRef fillPath = [[self class] createRoundRectPathForBoundingRect:self.bounds cornerRadius:self.cornerRadius];
    CGContextAddPath(context, fillPath);
    [self.color setFill];    
    CGContextFillPath(context);
    CGPathRelease(fillPath);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextSetLineWidth(context, self.borderWidth);
    CGPathRef borderPath = [[self class] createRoundRectPathForBoundingRect:CGRectInset(self.bounds, self.borderWidth * 0.5, self.borderWidth * 0.5) cornerRadius:self.cornerRadius];
    [[UIColor colorWithWhite:0.6 alpha:1.0] setStroke];    
    CGContextAddPath(context, borderPath);
    CGContextSetShadowWithColor(context, CGSizeMake(0, self.borderWidth), 0,[UIColor colorWithWhite:1.0 alpha:0.8].CGColor); 
    CGContextStrokePath(context);            
    CGPathRelease(borderPath);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
     */
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGPathRef path = [[self class] newLeftRoundRectPathForBoundingRect:CGRectMake(0, 0, self.bounds.size.width * 0.5 + 1.0f, self.bounds.size.height) cornerRadius:7.0];
    self.touchDownLayer.path = path;
    CGPathRelease(path);            
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

+ (CGPathRef)newLeftRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    const NSUInteger inset = 1.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minx = CGRectGetMinX(rect) , /*midx = CGRectGetMidX(rect),*/ maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + inset;
    miny = miny + inset;
    
    maxx = maxx - inset;
    maxy = maxy - inset;
    
    CGPathMoveToPoint(path, NULL, maxx, miny);
    CGPathAddArcToPoint(path, NULL, minx, miny, minx, midy, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minx, maxy, maxx, maxy, cornerRadius);
    CGPathAddLineToPoint(path, NULL, maxx, maxy);
    return path;
}

+ (CGPathRef)newRightRoundRectPathForBoundingRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    const NSUInteger inset = 1.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minx = CGRectGetMinX(rect) , /*midx = CGRectGetMidX(rect),*/ maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + inset;
    miny = miny + inset;
    
    maxx = maxx - inset;
    maxy = maxy - inset;
    
    CGPathMoveToPoint(path, NULL, minx, miny);
    CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxx, maxy, minx, maxy, cornerRadius);
    CGPathAddLineToPoint(path, NULL, minx, maxy);
    return path;
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
