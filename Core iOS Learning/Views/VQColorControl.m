//
//  VQColorControl.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/22.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQColorControl.h"

@interface VQColorControl ()
@property (nonatomic, strong) UIColor *value;
@end

@implementation VQColorControl
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:1.0];
    }
    
    return self;
}

#pragma mark - Private Method 
- (void)updateColorForTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat hue = touchPoint.x / self.bounds.size.width;
    CGFloat saturation = touchPoint.y / self.bounds.size.height;
    
    self.value = [UIColor colorWithHue:hue saturation:saturation brightness:1.0 alpha:1.0];
    self.backgroundColor = self.value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Override Method
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // 调用sendActionsForControlEvents可以实现事件派发功能。控件是通过向UIApplication单例发送消息来实现将某一事件发送给目标对象。UIApplication对象是所有消息的集中派发点。
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updateColorForTouch:touch];
    
    return YES;
}

-  (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    // 判断触摸点是否在视图内
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
        [self updateColorForTouch:touch];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self updateColorForTouch:touch];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
