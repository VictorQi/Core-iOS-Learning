//
//  VQImageView.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/12.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQImageView.h"
#import "UIView+transform.h"

@interface VQImageView () <UIGestureRecognizerDelegate>

@end

@implementation VQImageView {
    CGFloat tx;
    CGFloat ty;
    CGFloat scale;
    CGFloat theta;
}
#pragma mark - Life Cycle
#pragma mark -
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        [self resetAllTranslation];
        
        [self addGestures];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self resetAllTranslation];
        
        [self addGestures];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        [self resetAllTranslation];
        
        [self addGestures];
    }
    return self;
}

#pragma mark - Touch Event
#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    
    // initialize translation offsets
    tx = self.transform.tx; ty = self.transform.ty;
    scale = self.scaleX; theta = self.rotation;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 3) {
        [self resetAllTranslation];
    }
}

#pragma mark - Private Method
#pragma mark -
- (void)addGestures {
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationHandler:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchHandler:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    self.gestureRecognizers = @[rotation, pinch, pan];
    
    for (UIGestureRecognizer *gest in self.gestureRecognizers) {
        gest.delegate = self;
    }
}

- (void)updateTransformWithOffset:(CGPoint)translation {
    self.transform = CGAffineTransformMakeTranslation(translation.x + tx, translation.y + ty);
    self.transform = CGAffineTransformRotate(self.transform, theta);
    
    if (scale > 0.5) {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
    } else {
        self.transform = CGAffineTransformScale(self.transform, 0.5, 0.5);
    }
    NSLog(@"transform is %@ , center is %@, new center is %@", NSStringFromCGAffineTransform(self.transform), NSStringFromCGPoint(self.center), NSStringFromCGPoint(CGPointMake(self.frame.origin.x + 108.0, self.frame.origin.y + 108.0)));
}

- (void)resetAllTranslation {
    self.transform = CGAffineTransformIdentity;
    tx = 0.0f; ty = 0.0f; scale = 1.0f; theta = 0.0f;
}

#pragma mark - Gesture Handler
#pragma mark -
- (void)panHandler:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    [self updateTransformWithOffset:translation];
}

- (void)rotationHandler:(UIRotationGestureRecognizer *)rotation {
    theta = rotation.rotation;
    [self updateTransformWithOffset:CGPointZero];
}

- (void)pinchHandler:(UIPinchGestureRecognizer *)pinch {
    scale = pinch.scale;
    [self updateTransformWithOffset:CGPointZero];
}

#pragma mark - Delegate
#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
