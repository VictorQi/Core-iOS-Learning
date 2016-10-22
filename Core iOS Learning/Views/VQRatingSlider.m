//
//  VQRatingSlider.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/22.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQRatingSlider.h"
#import "Masonry.h"

#define OFF_ART	[UIImage imageNamed:@"Star-White-Half.png"]
#define ON_ART	[UIImage imageNamed:@"Star-White.png"]

@interface VQRatingSlider ()
@property (nonatomic, assign) NSInteger value;
@end

@implementation VQRatingSlider
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25f];
        [self configureUI];
    }
    
    return self;
}

#pragma mark - UI Configuration
- (void)configureUI {
    UIView *refView = self;
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starview = [[UIImageView alloc]init];
        starview.image = OFF_ART;
        [self addSubview:starview];
        
        [starview mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.leading.equalTo(refView).offset(12);
            } else {
                make.leading.equalTo(refView.mas_trailing).offset(12);
            }
            if (i == 4) {
                make.trailing.equalTo(self).offset(-12);
            }
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        refView = starview;
    }
}

#pragma mark - Private Method
- (void)updateValueAtPoint:(CGPoint)point {
    NSInteger newValue = 0;
    UIImageView *changeView = nil;
    for (UIImageView *imgV in self.subviews) {
        if (point.x < imgV.frame.origin.x) {
            imgV.image = OFF_ART;
        } else {
            changeView = imgV;
            imgV.image = ON_ART;
            newValue++;
        }
    }
    
    if (self.value != newValue) {
        self.value = newValue;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [UIView animateWithDuration:0.15 animations:^{
            changeView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
               changeView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

#pragma mark - Override Method
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updateValueAtPoint:touchPoint];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside ];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    
    [self updateValueAtPoint:touchPoint];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
