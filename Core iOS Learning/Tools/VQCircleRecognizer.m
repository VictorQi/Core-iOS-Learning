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
@property (nonatomic, readwrite, assign) CGRect circleRect;
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
    
    self.circleRect = testForCircle([self.points copy], self.firstTouchDate);
    BOOL detectionSuccess = CGRectEqualToRect(CGRectZero, self.circleRect);
    if (detectionSuccess) {
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)drawCircleInView:(CGRect)circle {
    if (CGRectEqualToRect(CGRectZero, circle)) {
        NSLog(@"failed circle");
        return;
    }
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circle];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.lineWidth = 1.0f;
    [self.view.layer addSublayer:circleLayer];
}
@end
