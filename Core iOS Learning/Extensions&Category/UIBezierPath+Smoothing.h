//
//  UIBezierPath+Smoothing.h
//  Core iOS Learning
//
//  Created by v.q on 16/9/14.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Smoothing)

/**
 获取平滑的贝塞尔曲线

 @param granularity 插值密度,插值越多越平滑

 @return 计算后的平滑曲线
 */
- (UIBezierPath *)smoothedPath:(NSInteger)granularity;

@end
