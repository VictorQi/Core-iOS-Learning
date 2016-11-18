//
//  VQDecodeViewController.m
//  Core iOS Learning
//
//  Created by v.q on 2016/11/3.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "VQDecodeViewController.h"
#include <VideoToolbox/VideoToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreVideo/CVHostTime.h>

@interface VQDecodeViewController () {
    NSData *spsData;
    NSData *ppsData;
}

@end

@implementation VQDecodeViewController

static void decoderCallback(void *decompressionOutputRefCon,
                              void *sourceFrameRefCon,
                              OSStatus status,
                              VTDecodeInfoFlags infoFlags,
                              CVImageBufferRef imageBuffer,
                              CMTime presentationTimeStamp,
                              CMTime presentationDuration)
{
    @autoreleasepool {
        if (status == noErr) {
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
