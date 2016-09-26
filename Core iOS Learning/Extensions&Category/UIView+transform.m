//
//  UIView+transform.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/12.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "UIView+transform.h"

@implementation UIView (transform)

// e.g. NSLog(@"Xscale: %f YScale: %f Rotation: %f", self.xscale, self.yscale, self.rotation * (180 / M_PI));

- (CGFloat)scaleX {
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat)scaleY {
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat)rotation {
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}
@end
