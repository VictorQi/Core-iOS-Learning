//
//  VQDragView.m
//  Core iOS Learning
//
//  Created by v.q on 2016/9/26.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQDragView.h"
#import "VQGeometry.h"
#import "VQPullView.h"

static const NSInteger kSwipeDragMin = 16;
static const NSInteger kDragLimitMax = 12;

typedef NS_ENUM(NSUInteger, SwipeTypes) {
    TouchUnknow,
    TouchSwipeLeft,
    TouchSwipeRight,
    TouchSwipeUp,
    TouchSwipeDown
};

@interface VQDragView () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL gestureWasHandled;
@property (nonatomic, assign) NSInteger pointCount;
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, strong) VQPullView *pullview;
@end

@implementation VQDragView {
    SwipeTypes touchType;
}
#pragma mark - 
#pragma mark - Life Cycle
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setUpGestures];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpGestures];
    }
    
    return self;
}

- (void)setUpGestures {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    pan.delegate = self;
    self.gestureRecognizers = @[pan];
}

#pragma mark - 
#pragma mark - Gesture Delegate
// 允许同时处理多个手势识别器
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark -
#pragma mark - Private Method
// 仅在其superview是scrollview类型时处理
- (void)panHandler:(UIGestureRecognizer *)gest {
    if (![self.superview isKindOfClass:[UIScrollView class]]) {
        NSLog(@"Only handle UIScrollView");
        return;
    }
    
    UIView *superView = self.superview.superview;
    UIScrollView *scrollview = (UIScrollView *)self.superview;
    
    CGPoint touchLocation = [gest locationInView:superView];
    
    if (gest.state == UIGestureRecognizerStateBegan) {
        self.gestureWasHandled = NO;
        self.pointCount = 1;
        self.startPoint = touchLocation;
    }
    
    if (gest.state == UIGestureRecognizerStateChanged) {
        self.pointCount ++;
        
        CGFloat dx = GEODx(self.startPoint, touchLocation);
        CGFloat dy = GEODy(self.startPoint, touchLocation);
        
        BOOL finished = YES;
        if (dx > kSwipeDragMin && ABS(dy) < kDragLimitMax) {
            touchType = TouchSwipeLeft;
        } else if ((-dx > kSwipeDragMin) && ABS(dy) < kDragLimitMax) {
            touchType = TouchSwipeRight;
        } else if (dy > kSwipeDragMin && ABS(dx) < kDragLimitMax) {
            touchType = TouchSwipeUp;
        } else if ((-dy > kSwipeDragMin) && ABS(dx) < kDragLimitMax) {
            touchType = TouchSwipeDown;
        } else {
            finished = NO;
        }
        
        if (!self.gestureWasHandled & finished &&
            (touchType == TouchSwipeDown)) {
            self.pullview.center = touchLocation;
            [superView addSubview:self.pullview];
            scrollview.scrollEnabled = NO;
            self.gestureWasHandled = YES;
        } else if (self.gestureWasHandled) {
            self.pullview.center = touchLocation;
        }
    }
    
    if (gest.state == UIGestureRecognizerStateEnded) {
        if (self.gestureWasHandled) {
            scrollview.scrollEnabled = YES;
        }
    }
}

#pragma mark -
#pragma mark - Getter
- (VQPullView *)pullview {
    if (!_pullview) {
        _pullview = [[VQPullView alloc]initWithImage:self.image];
        _pullview.backgroundColor = [UIColor clearColor];
    }
    return _pullview;
}
@end
