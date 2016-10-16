//
//  VQSecondViewController.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/16.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQSecondViewController.h"
#import "VQPushButton.h"
#import "Masonry.h"

@interface VQSecondViewController ()
@property (nonatomic, strong) VQPushButton *pushBtn;
@end

@implementation VQSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pushBtn = [VQPushButton button];
    [self.view addSubview:self.pushBtn];
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
    }];
    [self.pushBtn addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushed:(VQPushButton *)aButton {
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

@end
