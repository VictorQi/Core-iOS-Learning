//
//  VQLockControl.h
//  Core iOS Learning
//
//  Created by v.q on 2016/11/14.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VQLockControl;

@protocol LockOwner <NSObject>
- (void)lockDidUpdate:(nullable VQLockControl *)sender;
@end

@interface VQLockControl : UIControl
@property (nonatomic, readonly) BOOL isUnlocked;

- (nullable instancetype)init NS_UNAVAILABLE;
+ (nullable instancetype)new NS_UNAVAILABLE;

+ (nullable instancetype)lockControlWithTarget:(nonnull id <LockOwner>)target;
@end
