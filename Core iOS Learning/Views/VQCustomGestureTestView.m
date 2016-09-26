//
//  VQCustomGestureTestView.m
//  Core iOS Learning
//
//  Created by Victor on 2016/9/26.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQCustomGestureTestView.h"
#import "VQCircleRecognizer.h"

@implementation VQCustomGestureTestView
#pragma mark - 
#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.backgroundColor = [UIColor darkGrayColor];
    self.userInteractionEnabled = YES;
    
    VQCircleRecognizer *circleGest = [[VQCircleRecognizer alloc]initWithTarget:self action:@selector(handleCircleRecognizer:)];
    [self addGestureRecognizer:circleGest];
}

#pragma mark - 
#pragma mark - Gesture Handler
- (void)handleCircleRecognizer:(UIGestureRecognizer *)gest {
    NSLog(@"Circle Recognized!");
}

@end
