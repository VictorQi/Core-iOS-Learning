//
//  FLCombo.m
//  SwiftLive
//
//  Created by Victor on 2016/10/24.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "FLCombo.h"
#import "Masonry.h"

static NSInteger const kTimerCountDown = 10; //倒数10个数
static CGFloat const kFireInterval = 0.5;  //0.5s一次计数

@interface FLCombo () {
    NSInteger _countdownNum;
    dispatch_queue_t _syncQueue;
}
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *countNum;
@property (nonatomic, strong) UILabel *comboLabel;
@end

@implementation FLCombo {
    CGRect originFrame;
    dispatch_source_t timer;
    dispatch_queue_t timerQueue;
}
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _countdownNum = kTimerCountDown;
        [self configureUI];
        [self addBackgroundAnimation];
        [self createCountTimer];
    }
    
    return self;
}

#pragma mark - Create Timer 
- (void)createCountTimer {
    NSString *label = [NSString stringWithFormat:@"%@.isolation.%p", [self class], self];
    timerQueue = dispatch_queue_create([label UTF8String], 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), kFireInterval * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ((strongSelf->_countdownNum) <= 0) {
            [strongSelf invalidateTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf countDownFinished];
            });
        } else{
            (strongSelf->_countdownNum)--;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setCurrentNumber:(strongSelf->_countdownNum) forLabel:strongSelf.countNum];
            });
        }
    });
    dispatch_resume(timer);
}

- (void)invalidateTimer {
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

- (void)resetTimer {
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), kFireInterval * NSEC_PER_SEC, 0);
    _countdownNum = kTimerCountDown;
}

#pragma mark - UI Configuration
- (void)configureUI {
    self.backgroundImage = ({
        UIImageView *imgv = [UIImageView new];
        imgv.image = [UIImage imageNamed:@"combo_light"];
        [self addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0.5);
            make.trailing.equalTo(self).offset(0.5);
            make.leading.top.equalTo(self);
        }];
        
        imgv;
    });
    self.backgroundImage.layer.opacity = 0.0; // 开始的时候背景无光晕
    
    self.image = ({
        UIImageView *imgv = [UIImageView new];
        imgv.image = [UIImage imageNamed:@"combo_normal"];
        imgv.highlightedImage = [UIImage imageNamed:@"combo_highlight"];
        [self addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.trailing.equalTo(self);
            make.leading.top.equalTo(self).priorityLow();
        }];
        
        imgv;
    });
    
    self.countNum = ({
        UILabel *label = [UILabel new];
        label.text = @"10";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont italicSystemFontOfSize:23];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(42);
        }];
        
        label;
    });
    
    self.comboLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"COMBO";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:8.5 weight:UIFontWeightRegular];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.countNum.mas_bottom).offset(10);
            make.bottom.equalTo(self).offset(-17);
            make.trailing.equalTo(self).offset(-14);
        }];
        
        label;
    });
    
    [self.countNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.comboLabel);
    }];
}

#pragma mark - Override Tracking Method
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, pt)) {
        self.image.highlighted = YES;
        [self resetTimer];
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    self.image.highlighted = NO;
    if (CGRectContainsPoint(self.bounds, pt)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

#pragma mark - Number & Light Animation
- (void)setCurrentNumber:(NSInteger)currentNum forLabel:(UILabel *)label {
    [UIView animateKeyframesWithDuration:0.2 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            label.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            label.transform = CGAffineTransformMakeScale(0.8, 0.8);
            label.alpha = 0.2;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.alpha = 1.0;
            label.text = [NSString stringWithFormat:@"%ld", currentNum];
        }];
    } completion:nil];
}

- (void)countDownFinished {
    originFrame = self.image.frame;
    CGPoint pt = originFrame.origin;
    CGFloat w = CGRectGetWidth(originFrame);
    CGFloat h = CGRectGetHeight(originFrame);
    [self.backgroundImage.layer removeAllAnimations];
    [UIView animateWithDuration:0.1
                          delay:0.0
         usingSpringWithDamping:30
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.image.frame = CGRectMake(pt.x - 0.3 * w, pt.y - 0.3 * h, 1.3 * w, 1.3 * h);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              self.image.frame = CGRectMake(pt.x + 0.9 * w, pt.y + 0.9 * h, 0.1 * w, 0.1 * h);
                                              self.countNum.hidden = YES;
                                              self.comboLabel.hidden = YES;
                                          }
                                          completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                          }];
                     }];
}

- (void)addBackgroundAnimation {
    CAKeyframeAnimation *twinkle = [CAKeyframeAnimation animation];
    twinkle.keyPath = @"opacity";
    twinkle.duration = 1.625;
    twinkle.values = @[@(0.0), @(1.0), @(0.0), @(1.0), @(0.0), @(1.0), @(0.0)];
    twinkle.keyTimes = @[@(0.0), @(10.0/39.0), @(20.0/39.0), @(23.0/39.0), @(26.0/39.0), @(29.0/39.0), @(1.0)];
    twinkle.autoreverses = YES;
    twinkle.repeatCount = HUGE_VALF;
    twinkle.fillMode = kCAFillModeForwards;
    twinkle.removedOnCompletion = NO;
    
    [self.backgroundImage.layer addAnimation:twinkle forKey:@"backgroundImageTwinkle"];
}

@end
