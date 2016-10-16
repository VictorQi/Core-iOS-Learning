//
//  TOUCHKitView.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/15.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "TOUCHKitView.h"

@implementation TOUCHKitView {
    NSSet *theTouches;
    UIImage *fingers;
}
#pragma mark - Life Cycle
+ (TOUCHKitView *)shareInstance {
    static TOUCHKitView *touchkitView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchkitView = [[TOUCHKitView alloc]initWithFrame:CGRectZero];
    });
    if (!touchkitView.superview) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        touchkitView.frame = keyWindow.bounds;
        [keyWindow addSubview:touchkitView];
    }
    return touchkitView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.multipleTouchEnabled = YES;
        _touchColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        theTouches = nil;
    }
    
    return self;
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    theTouches = touches;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    theTouches = touches;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    theTouches = nil;
    [self setNeedsDisplay];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, self.bounds);
    
    CGFloat size = 25.0f;
    
    for (UITouch *touch in theTouches) {
        [[[UIColor grayColor] colorWithAlphaComponent:0.5f] set];
        CGPoint aPoint = [touch locationInView:self];
        CGContextAddEllipseInRect(context, CGRectMake(aPoint.x - size, aPoint.y - size, size * 2.0, size * 2.0));
        CGContextFillPath(context);
        
        CGFloat dsize = 1.0f;
        [self.touchColor set];
        CGContextAddEllipseInRect(context, CGRectMake(aPoint.x - size - dsize, aPoint.y - size - dsize, 2 * (size - dsize), 2 * (size - dsize)));
        CGContextFillPath(context);
    }
    
    theTouches = nil;
}
@end
