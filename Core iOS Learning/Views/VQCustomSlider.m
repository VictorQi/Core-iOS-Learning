//
//  VQCustomSlider.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/20.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQCustomSlider.h"
#import "VQProjectUtility.h"

@implementation VQCustomSlider {
    CGFloat previousValue;
}
#pragma mark - Class Method
+ (nonnull VQCustomSlider *)slider {
    VQCustomSlider *slider = [[VQCustomSlider alloc]initWithFrame:(CGRect){.size = CGSizeMake(200.0, 40.0)}];
    
    return slider;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        previousValue = CGFLOAT_MIN;
        self.value = 0.0;
        
        UIImage *thumb = [VQProjectUtility simpleThumb];
        [self setThumbImage:thumb forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(updateThumb:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    
    return self;
}

#pragma mark - Private Method
- (void)startDrag:(UISlider *)aslider {
    if (aslider == self) {
        self.frame = CGRectInset(self.frame, 0.0, -30.f);
    }
}

- (void)endDrag:(UISlider *)aslider {
    if (aslider == self) {
        self.frame = CGRectInset(self.frame, 0.0, 30.f);
    }
}

- (void)updateThumb:(UISlider *)aslider {
    if (aslider == self) {
        if (self.value < 0.98 && (ABS(self.value - previousValue) < 0.1f)) {
            return;
        }
        
        UIImage *customImg = [VQProjectUtility thumbWithLevel:self.value];
        [self setThumbImage:customImg forState:UIControlStateHighlighted];
        previousValue = self.value;
    }
}

@end
