//
//  VQPushButton.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/16.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQPushButton.h"

#define CAPWIDTH    55.0f
#define INSETS      (UIEdgeInsets){0.0f, CAPWIDTH, 0.0f, CAPWIDTH}
#define BASEGREEN   [[UIImage imageNamed:@"green-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHGREEN   [[UIImage imageNamed:@"green-in.png"] resizableImageWithCapInsets:INSETS]
#define BASERED     [[UIImage imageNamed:@"red-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHRED     [[UIImage imageNamed:@"red-in.png"] resizableImageWithCapInsets:INSETS]

@interface VQPushButton ()

@property (nonatomic, assign) BOOL isOn;

@end

@implementation VQPushButton
#pragma mark - Life Cycle
+ (instancetype)button {
    VQPushButton *button = [VQPushButton buttonWithType:UIButtonTypeCustom];
 
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setBackgroundImage:BASEGREEN forState:UIControlStateNormal];
    [button setBackgroundImage:PUSHGREEN forState:UIControlStateHighlighted];
    
    [button setTitle:@"On" forState:UIControlStateNormal];
    [button setTitle:@"On" forState:UIControlStateHighlighted];
    button.isOn = YES;
    
    [button addTarget:button action:@selector(toggleButton:) forControlEvents: UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Private Method
- (void)toggleButton:(UIButton *)aBtn {
    self.isOn = !self.isOn;
    if (self.isOn) {
        [self setBackgroundImage:BASEGREEN forState:UIControlStateNormal];
        [self setBackgroundImage:PUSHGREEN forState:UIControlStateHighlighted];
        [self setTitle:@"On" forState:UIControlStateNormal];
        [self setTitle:@"On" forState:UIControlStateHighlighted];
    } else {
        [self setBackgroundImage:BASERED forState:UIControlStateNormal];
        [self setBackgroundImage:PUSHRED forState:UIControlStateHighlighted];
        [self setTitle:@"Off" forState:UIControlStateNormal];
        [self setTitle:@"Off" forState:UIControlStateHighlighted];
    }
}
@end
