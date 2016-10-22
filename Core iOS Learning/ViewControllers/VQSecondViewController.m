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
    [ratingSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushed:(VQPushButton *)aButton {
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

- (void)updateValue:(UISlider *)aSlider {
    // Scale the title view
//    imageView.transform = CGAffineTransformMakeScale(1.0f + 4.0f * aSlider.value, 1.0f);
}

@end
