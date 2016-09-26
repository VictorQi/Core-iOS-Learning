//
//  VQPullView.m
//  Core iOS Learning
//
//  Created by v.q on 2016/9/26.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQPullView.h"

@implementation VQPullView {
    CGPoint previousLocation;
}
#pragma mark - Life Cycle
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
        self.gestureRecognizers = @[pan];
    }
    return self;
}

#pragma mark - Touch Handler
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    
    previousLocation = self.center;
}

- (void)panHandler:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.superview];
    self.center = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
}
@end
