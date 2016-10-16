//
//  TOUCHOverlayWindow.m
//  Core iOS Learning
//
//  Created by v.q on 2016/10/15.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "TOUCHOverlayWindow.h"
#import "TOUCHKitView.h"

@implementation TOUCHOverlayWindow

- (void)sendEvent:(UIEvent *)event {
    NSSet *touches = [event allTouches];
    NSMutableSet *began = nil;
    NSMutableSet *moved = nil;
    NSMutableSet *ended = nil;
    NSMutableSet *canceled = nil;
    
    for (UITouch *touch in touches) {
        switch ([touch phase]) {
            case UITouchPhaseBegan: {
                if (!began) {
                    began = [NSMutableSet setWithCapacity:3];
                }
                [began addObject:touch];
            } break;
            case UITouchPhaseMoved: {
                if (!moved) {
                    moved = [NSMutableSet setWithCapacity:3];
                }
                [moved addObject:touch];
            } break;
            case UITouchPhaseEnded: {
                if (!ended) {
                    ended = [NSMutableSet setWithCapacity:3];
                }
                [ended addObject:touch];
            } break;
            case UITouchPhaseCancelled: {
                if (!canceled) {
                    canceled = [NSMutableSet setWithCapacity:3];
                }
                [canceled addObject:touch];
            } break;
            default:
                break;
        }
    }
    
    if (began.count > 0) {
        [[TOUCHKitView shareInstance]touchesBegan:began withEvent:event];
    }
    if (moved.count > 0) {
        [[TOUCHKitView shareInstance]touchesMoved:moved withEvent:event];
    }
    if (ended.count > 0) {
        [[TOUCHKitView shareInstance]touchesEnded:ended withEvent:event];
    }
    if (canceled.count > 0) {
        [[TOUCHKitView shareInstance]touchesCancelled:canceled withEvent:event];
    }
    
    [super sendEvent:event];
}

@end
