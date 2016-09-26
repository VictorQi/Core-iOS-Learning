//
//  VQCircleRecognizer.m
//  Core iOS Learning
//
//  Created by v.q on 2016/9/25.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQCircleRecognizer.h"
#import "VQGeometry.h"
#import "UIBezierPath+Points.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface VQCircleRecognizer ()
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSDate *firstTouchDate;
@end

@implementation VQCircleRecognizer

- (void)reset {
    [super reset];

    [self.points removeAllObjects];
    self.points = nil;
    self.firstTouchDate = nil;
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    self.points = [NSMutableArray arrayWithCapacity:3];
    self.firstTouchDate = [NSDate date];
    UITouch *touch = [touches anyObject];
    [self.points addObject:[NSValue valueWithCGPoint:[touch locationInView:self.view]]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    [self.points addObject:[NSValue valueWithCGPoint:[touch locationInView:self.view]]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGRect circleRect = testForCircle(self.points, self.firstTouchDate);
    BOOL detectionSuccess = !CGRectEqualToRect(CGRectZero, circleRect);
    if (detectionSuccess) {
        [self drawCircleInView:circleRect];
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)drawCircleInView:(CGRect)circle {

    CGRect centerRect = GEORectAroundCenter(GEORectGetCenter(circle), 2.0f, 2.0f);
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithOvalInRect:centerRect];
    CAShapeLayer *centerLayer = [CAShapeLayer layer];
    centerLayer.path = centerPath.CGPath;
    centerLayer.lineWidth = 2.0f;
    centerLayer.fillColor = [UIColor redColor].CGColor;
    centerLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:centerLayer];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circle];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.lineWidth = 1.0f;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:circleLayer];
}
@end
