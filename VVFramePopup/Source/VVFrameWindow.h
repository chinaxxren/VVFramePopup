//
// Created by Tank on 2019-07-31.
// Copyright (c) 2019 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VVFramePopupView;


@interface VVFrameWindow : UIWindow

@property(nonatomic, assign) BOOL touchWildToHide;

+ (VVFrameWindow *)sharedWindow;

- (UIView *)attachView;

@end