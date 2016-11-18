//
//  VQLockControl.m
//  Core iOS Learning
//
//  Created by v.q on 2016/11/14.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQLockControl.h"

@interface VQLockControl ()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *lockView;
@property (nonatomic, strong) UIImageView *trackView;
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) MASConstraint *thumbLeadingConstraint;
@property (nonatomic, assign) BOOL isUnlocked;
@end

@implementation VQLockControl
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _isUnlocked = NO;
        [self configureUI];
    }
    
    return self;
}

+ (instancetype)lockControlWithTarget:(id<LockOwner>)target {
    VQLockControl *lock = [[VQLockControl alloc]initWithFrame:CGRectZero];
    [lock addTarget:target action:@selector(lockDidUpdate:) forControlEvents:UIControlEventValueChanged];
    return lock;
}

#pragma mark - UI Configuration
- (void)configureUI {
    self.backgroundView = ({
        UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lockBg"]];
        [self addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        imgv;
    });
    
    self.lockView = ({
        UIImageView *imgv = [UIImageView new];
        imgv.image = [UIImage imageNamed:@"lockClosed"];
        imgv.highlightedImage = [UIImage imageNamed:@"lockOpen"];
        [self addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_bottom).multipliedBy(0.35);
        }];
        
        imgv;
    });
    
    self.trackView = ({
        UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track"]];
        [self addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(201);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_bottom).multipliedBy(0.8);
        }];
        
        [imgv setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
        [imgv setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        
        imgv;
    });
    
    self.thumbView = ({
        UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"thumb"]];
        [self.trackView addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.trackView);
            self.thumbLeadingConstraint = make.leading.equalTo(self.trackView);
            make.trailing.lessThanOrEqualTo(self.trackView);
        }];
        
        imgv;
    });
}

#pragma mark - Control Event Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint tp = [touch locationInView:self];
    // 扩大trackview的判定点击范围
    CGRect largeTracking = CGRectInset(self.trackView.frame, -20.f, -20.f);
        
    if (!CGRectContainsPoint(largeTracking, tp)) {
        return NO;
    }
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint tp = [touch locationInView:self];
    CGRect largeTracking = CGRectInset(self.trackView.frame, -20.f, -20.f);
    
    if (!CGRectContainsPoint(largeTracking, tp)) {
        [self.thumbLeadingConstraint setOffset:0];
        [UIView animateWithDuration:0.2 animations:^{
            [self.trackView layoutIfNeeded];
        }];
        return NO;
    }
    
    tp = [touch locationInView:self.trackView];
    
    [self.thumbLeadingConstraint setOffset:tp.x];
    NSLog(@"offset is %f", tp.x);
    [UIView animateWithDuration:0.1 animations:^{
        [self.trackView layoutIfNeeded];
    }];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint tp = [touch locationInView:self.trackView];
    if (tp.x > (self.trackView.frame.size.width * 0.75)) {
        self.lockView.highlighted = YES;
        self.isUnlocked = YES;
        self.userInteractionEnabled = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self resetLock];
        }];
    } else {
        [self resetLock];
    }
    
    if (!CGRectContainsPoint(self.trackView.bounds, tp)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)resetLock {
    self.alpha = 1.0;
    self.userInteractionEnabled = YES;
    self.lockView.highlighted = NO;
    self.isUnlocked = NO;
    [self.thumbLeadingConstraint setOffset:0.0];
    [UIView animateWithDuration:0.2 animations:^{
        [self.trackView layoutIfNeeded];
    }];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
