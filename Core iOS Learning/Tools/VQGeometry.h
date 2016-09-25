
//
//  VQGeometry.h
//  Core iOS Learning
//
//  Created by v.q on 2016/9/25.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

BOOL floatEqual(CGFloat a, CGFloat b);

CGFloat degrees(CGFloat radians);
CGFloat radians(CGFloat degrees);

CGFloat GEODistance(CGPoint p1, CGPoint p2);
CGPoint GEOPointOffset(CGPoint aPoint, CGFloat dx, CGFloat dy);
CGFloat GEODx(CGPoint p1, CGPoint p2);
CGFloat GEODy(CGPoint p1, CGPoint p2);

NSInteger GEOSigned(CGFloat x);

CGPoint pointWithOrigin(CGPoint pt, CGPoint origin);

#define RECTSTRING(_aRect_)		NSStringFromCGRect(_aRect_)
#define POINTSTRING(_aPoint_)	NSStringFromCGPoint(_aPoint_)
#define SIZESTRING(_aSize_)		NSStringFromCGSize(_aSize_)

CGPoint GEORectGetCenter(CGRect rect);
CGRect GEOGetRectCenteredInRect(CGRect rect, CGRect mainRect);
CGRect GEORectAroundCenter(CGPoint center, CGFloat dx, CGFloat dy);
CGFloat GEODotProduct(CGPoint v1, CGPoint v2);

/**
 圆形验证
 */
CGRect testForCircle(NSArray *points, NSDate *firstTouchDate);
