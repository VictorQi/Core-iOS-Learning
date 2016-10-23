//
//  VQScrollWheel.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/23.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQScrollWheel.h"
#import "Masonry.h"

@interface VQScrollWheel ()
@property(nonatomic, readwrite, assign) CGFloat theta;
@property(nonatomic, readwrite, assign) CGFloat value;
@end

@implementation VQScrollWheel
#pragma mark - Help Function
CGPoint centeredPoint(CGPoint point, CGPoint center) {
    return CGPointMake(point.x - center.x, point.y - center.y);
}

CGFloat getAngles(CGPoint point, CGPoint center) {
    CGPoint p = centeredPoint(point, center);
    CGFloat h = sqrt(p.x * p.x + p.y * p.y);
    CGFloat a = p.x;
    CGFloat baseAngle = acos(a/h) * 180.f / M_PI;
    
    if (point.y > center.y) { //点在第三四象限
        baseAngle = 360.f - baseAngle;
    }
    return baseAngle;
}

BOOL pointInsideRadius(CGPoint p1, CGFloat r, CGPoint c1)
{
    CGPoint pt = centeredPoint(p1, c1);
    CGFloat xsquared = pt.x * pt.x;
    CGFloat ysquared = pt.y * pt.y;
    CGFloat h = sqrt(xsquared + ysquared);
    if (h < r) {
        return YES;
    }
    return NO;
}

UIImage *getWheelImage(CGSize imageSize) {
    CGRect baseRect = (CGRect){.size = imageSize};
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithPatternImage:[UIImage imageNamed:@"wheel"]].CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(ctx, 59);
    CGPathAddArc(path, NULL, CGRectGetMidX(baseRect), CGRectGetMidY(baseRect), 33, 0, 2*M_PI, 0);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgv = [UIImageView new];
        imgv.image = getWheelImage(CGSizeMake(200, 200));
        [self addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - Override Tracking Method
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    CGPoint cp = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // self.value = 0.0f; // Uncomment to set each touch to a separate value calculation
    
    // First touch must touch the gray part of the wheel
    if (!pointInsideRadius(p, cp.x, cp)) {
        return NO;
    }
    if (pointInsideRadius(p, 33.0f, cp)) {
        return NO;
    }
    
    // Set the initial angle
    self.theta = getAngles(p, cp);
    
    // Establish touch down
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint p = [touch locationInView:self];
    CGPoint cp = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Touch updates
    if (CGRectContainsPoint(self.bounds, p)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    // falls outside too far, with boundary of 50 pixels. Inside strokes treated as touched
    if (!pointInsideRadius(p, cp.x + 50.0f, cp)){
        return NO;
    }
    CGFloat newtheta = getAngles(p, cp);
    CGFloat dtheta = newtheta - self.theta;
    
    // correct for edge conditions
    NSInteger ntimes = 0;
    while ((ABS(dtheta) > 300.0f) && (ntimes++ < 4)) {
        if (dtheta > 0.0f) {
            dtheta -= 360.0f;
        } else {
            dtheta += 360.0f;
        }
    }
    // Update current values
    self.value -= dtheta / 360.0f;
    self.theta = newtheta;
    
    // Send value changed alert
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Test if touch ended inside or outside
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}


- (void)cancelTrackingWithEvent:(UIEvent *)event {
    // Cancel
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
