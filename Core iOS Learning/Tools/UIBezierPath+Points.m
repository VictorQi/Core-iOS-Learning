//
//  UIBezierPath+Points.m
//  Core iOS Learning
//
//  Created by v.q on 2016/9/25.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "UIBezierPath+Points.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

@implementation UIBezierPath (Points)

void getPointsFromBezier(void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // 取出路径元素的类型和相应的点
    CGPathElementType type = element->type;
    CGPoint *points = element->points;

#pragma message "这步不是很明白"
    if (type != kCGPathElementCloseSubpath) {
        [bezierPoints addObject:VALUE(0)];
        if (type != kCGPathElementMoveToPoint &&
            type != kCGPathElementAddLineToPoint) {
            [bezierPoints addObject:VALUE(1)];
        }
    }
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:VALUE(2)];
    }
}


- (NSArray *)points {
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:3];
    CGPathApply(self.CGPath, (__bridge void *)points, getPointsFromBezier);
    return [points copy];
}

@end
