//
//  VQProjectUtility.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/20.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQProjectUtility.h"

@implementation VQProjectUtility
+ (nullable UIImage *)thumbWithLevel:(CGFloat)aLevel {
    CGFloat INSET_AMT = 1.5f;
    CGRect baseRect = CGRectMake(0.0, 0.0, 40.0, 100.0);
    CGRect thumbRect = (CGRect){0.0, 40.0, 40.0, 20.0};
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画游标的里面矩形
    [[UIColor grayColor] setFill];
    CGContextAddRect(ctx, CGRectInset(thumbRect, INSET_AMT, INSET_AMT));
    CGContextFillPath(ctx);
    
    // 画游标的外部轮廓描边
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, 2.0);
    CGContextAddRect(ctx, CGRectInset(thumbRect, 2.0 * INSET_AMT, 2.0 * INSET_AMT));
    CGContextStrokePath(ctx);
    
    // 画游标上面的值指示器内部圆
    CGRect elliseRect = CGRectMake(0.0, 0.0, 40.0, 40.0);
    [[UIColor colorWithWhite:aLevel alpha:1.0] setFill];
    CGContextAddEllipseInRect(ctx, elliseRect);
    CGContextFillPath(ctx);
    	
    // 写数值
    NSString *numString = [NSString stringWithFormat:@"%.1f", aLevel];
    UIColor *color = (aLevel > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Georgia" size:20.f];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{
                           NSFontAttributeName : font,
                           NSParagraphStyleAttributeName : style,
                           NSForegroundColorAttributeName : color
                           };
    [numString drawInRect:CGRectInset(elliseRect, 0.0, 6.0) withAttributes:attr];
    
    // 值指示器的外圆描边
    [[UIColor cyanColor] setStroke];
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextAddEllipseInRect(ctx, CGRectInset(elliseRect, 2.0f, 2.0f));
    CGContextStrokePath(ctx);
    
    UIImage *theImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImg;
}

+ (nullable UIImage *)simpleThumb {
    CGFloat INSET_AMT = 1.5f;
    CGRect baseRect = CGRectMake(0.0, 0.0, 40.0, 100.0);
    CGRect thumbRect = (CGRect){0.0, 40.0, 40.0, 20.0};
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画游标的里面矩形
    [[UIColor grayColor] setFill];
    CGContextAddRect(ctx, CGRectInset(thumbRect, INSET_AMT, INSET_AMT));
    CGContextFillPath(ctx);
    
    // 画游标的外部轮廓描边
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, 2.0);
    CGContextAddRect(ctx, CGRectInset(thumbRect, 2.0 * INSET_AMT, 2.0 * INSET_AMT));
    CGContextStrokePath(ctx);

    UIImage *theImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImg;
}
@end
