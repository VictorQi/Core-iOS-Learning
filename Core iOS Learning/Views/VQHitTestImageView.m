//
//  VQHitTestImageView.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/13.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQHitTestImageView.h"

#pragma message "我太菜了，无法实现对于Retina以及更高分辨率的图片进行采点分析"

@implementation VQHitTestImageView {
    NSData *imageData;
}

#pragma mark - Private Convert Method
#pragma mark -
static NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w, CGFloat scale) {
    return (y * w * 4 * scale + x * 4 * scale);
}

NSData *getBitmapFromImage(UIImage *sourceImage) {
    if (!sourceImage) {
        return nil;
    }
    CGImageRef imgRef = sourceImage.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return nil;
    }
    
    NSUInteger width = CGImageGetWidth(imgRef);
    NSUInteger height = CGImageGetHeight(imgRef);
    
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imgRef);
    NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(imgRef);

    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGRect rect = (CGRect){.size = CGSizeMake(width, height)};
    CGContextDrawImage(context, rect, imgRef);
 
    NSData *data = [NSData dataWithBytes:CGBitmapContextGetData(context) length:(width * height * bytesPerRow)];
    
    CGContextRelease(context);
    
    return data;
}

#pragma mark - Life Cycle
#pragma mark -
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        imageData = getBitmapFromImage(image);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        if (self.image) {
            imageData = getBitmapFromImage(self.image);
        }
    }
    return self;
}

#pragma mark - Override Method 
#pragma mark -
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(self.bounds, point)) {
        NSLog(@"Not in");
        return NO;
    }
    Byte *bytes = (Byte *)imageData.bytes;
    CGImageRef inputImgRef = self.image.CGImage;
    NSUInteger refWidth = CGImageGetWidth(inputImgRef);

    uint offset = (uint)alphaOffset(point.x, point.y, refWidth, self.image.scale);
    NSLog(@"offset is %u , value is %u", offset, bytes[offset]);
    return (bytes[offset] > 85);  // alpha > 33%
}

@end
