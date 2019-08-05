//
// Created by Tank on 2019-07-31.
// Copyright (c) 2019 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVFramePopupView : UIView

@property(nonatomic, strong) UIView *attachedView;
@property(nonatomic, weak) UIView *fieldResponder;
@property(nonatomic, assign) BOOL bottom;

- (void)show;

- (void)hide;

@end
