//
//  VQColorControl.h
//  Core iOS Learning
//
//  Created by v.q on 2016/10/22.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 实现一个简单的颜色选取器，用户可以触摸控件，或者在控件内拖曳来选取颜色。手指在屏幕上左右移动时颜色的色相Hue改变，上下移动时饱和度Saturation改变。基于这个我们可以自己定义一个跟Apple一样的蜡笔型的颜色选择器
 */
@interface VQColorControl : UIControl
@property (nonatomic, readonly, strong) UIColor *value;
@end
