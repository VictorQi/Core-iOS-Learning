//
//  VQRibbonPull.m
//  Core iOS Learning
//
//  Created by v.q on 2016/11/13.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQRibbonPull.h"
@import AudioToolbox;

static NSData *getBitmapFromImage(UIImage *sourceImage) {
    if (!sourceImage) { return nil; }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        NSLog(@"Create colorspace failed");
        return nil;
    }
    
    CGImageRef sourceCGImg = sourceImage.CGImage;
    size_t wid = CGImageGetWidth(sourceCGImg);
    size_t hei = CGImageGetHeight(sourceCGImg);
    size_t bitsPerComp = CGImageGetBitsPerComponent(sourceCGImg);
    size_t bytesPerRow = CGImageGetBytesPerRow(sourceCGImg);
    CGContextRef context = CGBitmapContextCreate(NULL, wid, hei, bitsPerComp, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        NSLog(@"Create bitmapcontext failed.");
        return nil;
    }
    
    CGRect rect = (CGRect){.size = CGSizeMake(wid, hei)};
    CGContextDrawImage(context, rect, sourceCGImg);
    
    NSData *data = [NSData dataWithBytes:CGBitmapContextGetData(context) length:(hei * bytesPerRow)];
    CGContextRelease(context);
    
    return data;
}

@interface VQRibbonPull () {
    CGRect _pullImgVOriginFrame;
}
@property (nonatomic, strong) UIImage             *ribbonImage;
@property (nonatomic, strong) UIImageView         *pullImageView;
@property (nonatomic, strong) UIMotionEffectGroup *motionEffectsGroup;
@property (nonatomic, copy)   NSData              *ribbonData;
@property (nonatomic, assign) NSInteger           wiggleCount;
@property (nonatomic, assign) CGPoint             touchDownPoint;
@end

@implementation VQRibbonPull
#pragma mark - Life Cycle 
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _wiggleCount = 0;
        _ribbonImage = [UIImage imageNamed:@"Ribbon"];
        _ribbonData = getBitmapFromImage(_ribbonImage);
        
        _pullImageView = [[UIImageView alloc]initWithImage:_ribbonImage];
        [self addSubview:_pullImageView];
        [_pullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(75.f - _ribbonImage.size.height);
            make.leading.equalTo(self).offset(5);
            make.trailing.equalTo(self).offset(-5);
            make.bottom.equalTo(self).offset(-100);
        }];
        
        [self startMotionEffects];
        
        [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0];
    }
    
    return self;
}

#pragma mark - Discoverability 
- (void)startMotionEffects {
    UIInterpolatingMotionEffect *motionX = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionX.minimumRelativeValue = @(-15.0);
    motionX.maximumRelativeValue = @(15.0);
    
    UIInterpolatingMotionEffect *motionY = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionY.minimumRelativeValue = @(-15.0);
    motionY.maximumRelativeValue = @(15.0);
    
    _motionEffectsGroup = [[UIMotionEffectGroup alloc]init];
    _motionEffectsGroup.motionEffects = @[motionX, motionY];
    
    [_pullImageView addMotionEffect:_motionEffectsGroup];
}

- (void)stopMotionEffects {
    [_pullImageView removeMotionEffect:_motionEffectsGroup];
    _motionEffectsGroup = nil;
}

- (void)wiggle {
    if (++_wiggleCount > 3) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _pullImageView.frame = CGRectOffset(_pullImgVOriginFrame, 0, 10.f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _pullImageView.frame = CGRectOffset(_pullImgVOriginFrame, 0, -10.f);
        }];
    }];
    
    [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0];
}

#pragma mark - Audio Effects
static void _systemSoundDidComplete(SystemSoundID ssID, void *clientData) {
    AudioServicesDisposeSystemSoundID(ssID);
    AudioServicesRemoveSystemSoundCompletion(ssID);
}

- (void)playingWhenClick {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"click" ofType:@"wav"];
    CFURLRef baseURL = (__bridge_retained CFURLRef)[NSURL fileURLWithPath:path];
    
    SystemSoundID sysSoundID;
    OSStatus status = AudioServicesCreateSystemSoundID(baseURL, &sysSoundID);
    CFRelease(baseURL);
    if (status != noErr) {
        NSLog(@"Create systemSoundID failed");
        return;
    }
    
    AudioServicesAddSystemSoundCompletion(sysSoundID, NULL, NULL, _systemSoundDidComplete, NULL);
    AudioServicesPlayAlertSound(sysSoundID);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _pullImgVOriginFrame = self.pullImageView.frame;
}

#pragma mark - Touch Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.pullImageView.frame, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        self.touchDownPoint = touchPoint;
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _wiggleCount = CGFLOAT_MAX;
    
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    
    CGFloat dy = MAX(touchPoint.y - _touchDownPoint.y, 0.0f);
    dy = MIN(dy, self.bounds.size.height - 75.0f);
    self.pullImageView.frame = CGRectOffset(_pullImgVOriginFrame, 0.0, dy);
    
    if (dy > 75.0f) {
        [self playingWhenClick];
        [UIView animateWithDuration:0.3 animations:^{
            self.pullImageView.frame = CGRectOffset(_pullImgVOriginFrame, 0.0, -dy);
        } completion:^(BOOL finished) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }];
        return NO;
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    } else {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pullImageView.frame = _pullImgVOriginFrame;
    }];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
