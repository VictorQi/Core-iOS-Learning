//
//  UIBezierPath+Smoothing.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/14.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "UIBezierPath+Smoothing.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

@interface UIBezierPath (Points)

- (NSArray *)points;

@end

@implementation UIBezierPath (Points)

void getPointsFromBezier(void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // 取出路径元素的类型和相应的点
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
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
    CGPathApply(self.CGPath, (__bridge void*)points, getPointsFromBezier);
    return [points copy];
}

@end

#define POINT(_INDEX_) \
        [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@implementation UIBezierPath (Smoothing)

- (UIBezierPath *)smoothedPath:(NSInteger)granularity {
    NSMutableArray *points = [self.points mutableCopy];  // 对NSArray对象进行mutableCopy，则是进行了深拷贝
    if (points.count < 4) {
        return [self copy];
    }
    
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    smoothedPath.lineWidth = self.lineWidth;
    
    // 丢掉前三个点(0..2)
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSInteger index = 1; index < 3; index ++) {
        [smoothedPath addLineToPoint:POINT(index)];
    }
    
    for (int index = 4; index < points.count; index ++) {
        CGPoint p0 = POINT(index - 3);
        CGPoint p1 = POINT(index - 2);
        CGPoint p2 = POINT(index - 1);
        CGPoint p3 = POINT(index);
        
        
        // 使用Catmull-Rom样条插值法，从p1 + dx/dy开始到p2结束的范围进行插值
        for (NSInteger i = 1; i < granularity; i++) {
            CGFloat t = (CGFloat)i * (1.0f / (CGFloat)granularity);
            CGFloat tt = t * t;
            CGFloat ttt = tt * t;
            
            CGPoint pi;
            pi.x =
            0.5f * (2 * p1.x + t * (p2.x - p0.x) +
                    tt * (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) +
                    ttt * (3 * p1.x - p0.x - 3 * p2.x + p3.x));
            pi.y =
            0.5f * (2 * p1.y + t * (p2.y - p0.y) +
                    tt * (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) +
                    ttt * (3 * p1.y - p0.y - 3 * p2.y + p3.y));
            
            [smoothedPath addLineToPoint:pi];
        }
        
        // 然后添加p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // 添加最后一个点，结束
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}

@end
