//
//  VQSmoothDrawingView.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/14.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQSmoothDrawingView.h"
#import "UIBezierPath+Smoothing.h"

@implementation VQSmoothDrawingView {
    UIBezierPath *path;
}

#pragma mark - Life Cycle
#pragma mark -
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.multipleTouchEnabled = NO;
    }
    return self;
}

#pragma mark - Touch Event
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    path = [UIBezierPath bezierPath];
    path.lineWidth = 4.0f;
    
    UITouch *touch = [touches anyObject];
    [path moveToPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    path = [path smoothedPath:10];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


#pragma mark - Drawing
#pragma mark -
- (void)drawRect:(CGRect)rect {
    [[UIColor purpleColor] set];
    [path stroke];
}

@end
