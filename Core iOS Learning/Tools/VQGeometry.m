//
//  VQGeometry.m
//  Core iOS Learning
//
//  Created by v.q on 2016/9/25.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQGeometry.h"

static const CGFloat kMaxDuration = 2.0f;

CGPoint GEOPointOffset(CGPoint aPoint, CGFloat dx, CGFloat dy)
{
    return CGPointMake(aPoint.x + dx, aPoint.y + dy);
}

// Equality Test - Shamelessly stolen from Sam "Svlad" Marshall
BOOL floatEqual(CGFloat a, CGFloat b)
{
    return (fabs(a-b) < FLT_EPSILON);
}

// Degrees from radians
CGFloat degrees(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

// Radians from degrees
CGFloat radians(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

/**
 获得给定矩形的中心点
 */
CGPoint GEORectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 使用给定的中心点和到两边的距离构建矩形
 */
CGRect GEORectAroundCenter(CGPoint center, CGFloat dx, CGFloat dy) {
    return  CGRectMake(center.x - dx, center.y - dy, 2.0 * dx, 2.0 * dy);
}

CGRect GEOGetRectCenteredInRect(CGRect rect, CGRect mainRect) {
    CGFloat dx = CGRectGetMidX(mainRect) - CGRectGetMidX(rect);
    CGFloat dy = CGRectGetMidY(mainRect) - CGRectGetMidY(rect);
    return CGRectOffset(rect, dx, dy);
}

CGFloat GEODotProduct(CGPoint v1, CGPoint v2) {
    CGFloat dot = v1.x * v2.x + v1.y * v2.y;
    CGFloat a = ABS(sqrt(v1.x * v1.x + v1.y * v1.y));
    CGFloat b = ABS(sqrt(v2.x * v2.x + v2.y * v2.y));
    dot /= (a * b);
    
    return dot;
}

CGFloat GEODistance(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    
    return sqrt(dx * dx + dy * dy);
}

CGFloat GEODx(CGPoint p1, CGPoint p2) {
    return p1.x - p2.x;
}

CGFloat GEODy(CGPoint p1, CGPoint p2) {
    return p1.y - p2.y;
}

NSInteger GEOSigned(CGFloat x) {
    return (x < 0.0f) ? (-1) : 1;
}

/**
 返回某一点相对于原点的坐标
 */
CGPoint pointWithOrigin(CGPoint pt, CGPoint origin) {
    return CGPointMake(pt.x - origin.x, pt.y - origin.y);
}

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

/**
 计算最小的外切矩形
 */
CGRect boundingRect(NSArray *points) {
    __block CGRect rect = CGRectZero;
    __block CGRect ptRect;
    
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint pt = [(NSValue *)obj CGPointValue];
        ptRect = CGRectMake(pt.x, pt.y, 0.0f, 0.0f);
        rect = CGRectEqualToRect(rect, CGRectZero) ?
        ptRect : CGRectUnion(rect, ptRect);
    }];
    
    return rect;
}

CGRect testForCircle(NSArray *points, NSDate *firstTouchDate) {
    if (points.count < 2) {
        NSLog(@"too fwe points (2) for circle");
        return CGRectZero;
    }
    
    // 验证1： 时间限制
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:firstTouchDate];
    NSLog(@"Transition duration: %0.2f", duration);
    
    if (duration > kMaxDuration) {
        NSLog(@"Excessive duration");
        return CGRectZero;
    }
    
    //验证2： 画圆的方向变化次数应该限制在4次
    __block NSInteger inflections = 0;
    for (NSInteger i = 2; i < (points.count - 1); i++) {
        CGFloat deltax = GEODx(POINT(i), POINT(i-1));
        CGFloat deltay = GEODy(POINT(i), POINT(i-1));
        CGFloat px = GEODx(POINT(i-1), POINT(i-2));
        CGFloat py = GEODy(POINT(i-1), POINT(i-2));
        
        if (GEOSigned(deltax) != GEOSigned(px) ||
            GEOSigned(deltay) != GEOSigned(py)) {
            inflections ++;
        }
    }
    
    if (inflections > 5) {
        NSLog(@"Excessive inflections");
        return CGRectZero;
    }
    
    //验证3： 起点与终点接近
    CGFloat tolerance = 20.f;
    if (GEODistance(POINT(0), POINT(points.count - 1)) > tolerance) {
        NSLog(@"Start is too far from end");
        return CGRectZero;
    }
    
    //验证4： 计算变化的角度
    CGRect circle = boundingRect(points);
    CGPoint center = GEORectGetCenter(circle);
    CGFloat distance = ABS(acos(GEODotProduct(pointWithOrigin(POINT(0), center), pointWithOrigin(POINT(1), center))));
    
    for (NSInteger i = 1; i < (points.count - 1); i++) {
        distance += ABS(acos(GEODotProduct(pointWithOrigin(POINT(i), center), pointWithOrigin(POINT(i + 1), center))));
    }
    
    // 弧度测试，圆是360度，用户至少要画45度，最多可以多画180度
    CGFloat transitToLerance = distance - 2 * M_PI;
    if (transitToLerance < 0.f) { // 小于2π
        if (transitToLerance < -(M_PI / 4.0)) { //小于45°
            NSLog(@"Transit too short");
            return CGRectZero;
        }
    }
    
    if (transitToLerance > M_PI) { //超过180°
        NSLog(@"Transit too long");
        return CGRectZero;
    }
    
    return circle;
}
