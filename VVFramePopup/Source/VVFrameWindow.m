//
// Created by Tank on 2019-07-31.
// Copyright (c) 2019 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "VVFrameWindow.h"

#import "VVFramePopupView.h"
#import "VVFramePopupCategory.h"

@interface VVFrameWindow () <UIGestureRecognizerDelegate>

@end

@implementation VVFrameWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.touchWildToHide = YES;

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        gesture.cancelsTouchesInView = NO;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }

    return self;
}

+ (VVFrameWindow *)sharedWindow {
    static VVFrameWindow *window;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[VVFrameWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });

    return window;
}

- (void)actionTap:(UITapGestureRecognizer *)gesture {
    if (self.touchWildToHide && !self.backgroundAnimating) {
        for (UIView *v in [self attachView].backgroundPopuView.subviews) {
            if ([v isKindOfClass:[VVFramePopupView class]]) {
                VVFramePopupView *popupView = (VVFramePopupView *) v;
                [popupView hide];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (touch.view == self.attachView.backgroundPopuView);
}

- (UIView *)attachView {
    return self.rootViewController.view;
}

@end
