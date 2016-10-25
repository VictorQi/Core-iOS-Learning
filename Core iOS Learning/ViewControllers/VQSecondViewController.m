//
//  VQSecondViewController.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/16.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQSecondViewController.h"
#import "Masonry.h"
#import "VQPushButton.h"
#import "VQCustomSlider.h"
#import "VQRatingSlider.h"
#import "FLCombo.h"

@interface VQSecondViewController ()
@property (nonatomic, strong) VQPushButton *pushBtn;
@end

@implementation VQSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.pushBtn = [VQPushButton button];
    [self.view addSubview:self.pushBtn];
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
    }];
    [self.pushBtn addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
    
    VQCustomSlider *slider = [VQCustomSlider slider];
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(100);
        make.width.mas_equalTo(240);
    }];
    
    VQRatingSlider *ratingSlider = [VQRatingSlider new];
    [self.view addSubview:ratingSlider];
    [ratingSlider addTarget:self action:@selector(handleStarSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [ratingSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    [self showComboView];
}

- (void)showComboView {
    FLCombo *combo = [FLCombo new];
    [self.view addSubview:combo];
    [combo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(self.view);
    }];
//    [self.view bringSubviewToFront:combo];
    [combo addTarget:self action:@selector(comboClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)comboClick:(FLCombo *)comb {
    static NSInteger clicktimes = 0;
    NSLog(@"combo click %ld", (long)clicktimes++);
}

- (void)pushed:(VQPushButton *)aButton {
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

- (void)updateValue:(UISlider *)aSlider {
    // Scale the title view
//    imageView.transform = CGAffineTransformMakeScale(1.0f + 4.0f * aSlider.value, 1.0f);
}

- (void)handleStarSliderChanged:(id)sender {
    if ([sender isKindOfClass:[VQRatingSlider class]]) {
        VQRatingSlider *slider = (VQRatingSlider *)sender;
        NSLog(@"%@", [NSString stringWithFormat:@"%ld Stars", (long)slider.value]);
    }
}

@end
