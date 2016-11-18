//
//  VQSecondViewController.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/16.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQSecondViewController.h"
#import "VQPushButton.h"
#import "VQCustomSlider.h"
#import "VQRatingSlider.h"
#import "FLCombo.h"
#import "VQRibbonPull.h"
#import "VQLockControl.h"

static CGFloat const kHiddenViewHeight = 120.f;

@interface VQSecondViewController () <LockOwner>
{
    BOOL _isHidden;
}
@property (nonatomic, strong) VQPushButton  *pushBtn;
@property (nonatomic, strong) VQRibbonPull  *ribbonPull;
@property (nonatomic, strong) UIView        *hiddenView;
@end

@implementation VQSecondViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;// 解决navigationbar的布局问题。
    
    _isHidden = YES;
    
    [self configureToolBar];
    
    [self configureUI];
    
    [self showComboView];
}

#pragma mark - Confugure ToolBar
- (void)configureToolBar {
    UIToolbar *tb = [[UIToolbar alloc]init];
    [self.view addSubview:tb];
    [tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.right.equalTo(self.view);
    }];
    
    NSMutableArray *tbItems = [NSMutableArray arrayWithCapacity:3];
    [tbItems addObject:BARBUTTON(@"Title", self, @selector(toolbarAction:))];
    [tbItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, self, nil)];
    [tbItems addObject:SYSBARBUTTON(UIBarButtonSystemItemAdd, self, nil)];
    [tbItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, self, nil)];
    [tbItems addObject:IMGBARBUTTON([UIImage imageNamed:@"Star"], self, @selector(toolbarAction:))];
    [tbItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, self, nil)];
    [tbItems addObject:CUSTOMBARBUTTON([[UISwitch alloc]init])];
    
    tb.items = [NSArray arrayWithArray:tbItems];
}

#pragma mark - Configure UI
- (void)configureUI {
    self.hiddenView = [UIView new];
    self.hiddenView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.hiddenView];
    [self.hiddenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(kHiddenViewHeight);
        make.top.equalTo(self.view).offset(-kHiddenViewHeight);
    }];
    
    self.ribbonPull = [[VQRibbonPull alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.ribbonPull];
    [self.ribbonPull mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view).offset(0);
    }];
    [self.ribbonPull addTarget:self action:@selector(updateDrawer:) forControlEvents:UIControlEventValueChanged];
    
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
    
    VQLockControl *lock = [VQLockControl lockControlWithTarget:self];
    [self.view addSubview:lock];
    [lock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

#pragma mark - Toolbar Action
- (void)toolbarAction:(UIBarButtonItem *)sender {
    NSLog(@"toolbar item clicked");
}

#pragma mark - LockOwner Protocol
- (void)lockDidUpdate:(VQLockControl *)sender {
    NSLog(@"locked or unlocked");
}

#pragma mark - Ribbon Pull
- (void)updateDrawer:(VQRibbonPull *)sender {
    if (_isHidden) {
        [self.hiddenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
        [self.ribbonPull mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kHiddenViewHeight);
        }];
    } else {
        [self.hiddenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-kHiddenViewHeight);
        }];
        [self.ribbonPull mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.2
          initialSpringVelocity:10.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    _isHidden = !_isHidden;
}

#pragma mark - Combo View
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

#pragma mark - Push Button
- (void)pushed:(VQPushButton *)aButton {
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

#pragma mark - Custom Slider
- (void)updateValue:(UISlider *)aSlider {
    // Scale the title view
//    imageView.transform = CGAffineTransformMakeScale(1.0f + 4.0f * aSlider.value, 1.0f);
}

#pragma mark - Ranking Slider
- (void)handleStarSliderChanged:(id)sender {
    if ([sender isKindOfClass:[VQRatingSlider class]]) {
        VQRatingSlider *slider = (VQRatingSlider *)sender;
        NSLog(@"%@", [NSString stringWithFormat:@"%ld Stars", (long)slider.value]);
    }
}

@end
