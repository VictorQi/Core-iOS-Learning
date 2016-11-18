//
//  VQPagedImageScrollView.m
//  Core iOS Learning
//
//  Created by v.q on 2016/11/17.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQPagedImageScrollView.h"

static NSString *const kLayerIndexKey = @"index";

@interface VQPagedImageScrollView ()
@property (nonatomic, strong) UIView *baseView;
@end

@implementation VQPagedImageScrollView
#pragma mark - Life Cycle 
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        _baseView = [UIView new];
        [self addSubview:_baseView];
    }
    
    return self;
}

#pragma mark - Layout Subview & Confirm ContentSize
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize currentSize = self.bounds.size;
    currentSize.width *= self.images.count;
    self.contentSize = currentSize;
}

#pragma mark - Override ContentSize Set Method
- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    
    self.baseView.frame = (CGRect){.size = contentSize};
}

#pragma mark - Property: images Set Method
- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    
    CGSize currentSize = self.bounds.size;
    currentSize.width *= images.count;
    self.contentSize = currentSize;
    
    [self.baseView removeConstraints:self.baseView.constraints];
    for (UIView *view in self.baseView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *leftView = nil;
    for (UIImage *img in images) {
        UIImageView *contentView = [[UIImageView alloc]initWithImage:img];
        contentView.contentMode = UIViewContentModeScaleAspectFit;
        contentView.clipsToBounds = YES;
        [self.baseView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self);
            if (leftView) {
                make.leading.equalTo(leftView.mas_trailing);
            } else {
                make.leading.equalTo(self.baseView);
            }
        }];
        leftView = contentView;
    }
}
@end
