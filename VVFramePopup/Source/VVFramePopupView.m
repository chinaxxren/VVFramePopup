//
// Created by Tank on 2019-07-31.
// Copyright (c) 2019 挖趣智慧科技（北京）有限公司. All rights reserved.
//

#import "VVFramePopupView.h"

#import "VVFrameWindow.h"
#import "VVFramePopupCategory.h"

#define VVWeakify(o)   __weak   typeof(self) vvwo = o;
#define VVStrongify(o) __strong typeof(self) o = vvwo;


@interface VVFramePopupView () <UIGestureRecognizerDelegate>

@property(nonatomic, assign) BOOL hasHideKeboard;
@property(nonatomic, assign) BOOL first;
@property(nonatomic, assign) CGFloat beforeY;
@property(nonatomic, assign) CGFloat afterY;
@property(nonatomic, assign) CGFloat keybordHeight;

@end

@implementation VVFramePopupView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.attachedView = [VVFrameWindow sharedWindow].attachView;
    self.bottom = YES;
    self.openField = NO;
    self.becomeResponder = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.first) {
        self.first = YES;
        self.beforeY = self.frame.origin.y;
    }
}

- (void)show {
    if (!self.attachedView) {
        self.attachedView = [VVFrameWindow sharedWindow].attachView;
    }
    [self.attachedView showBackground];

    [self showAnimation];
}

- (void)showWithView:(UIView *)view {
    self.attachedView = view;
    [self.attachedView showBackground];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delegate = self;
    [self.attachedView.backgroundPopuView addGestureRecognizer:gesture];
     
    [self showAnimation];
}

- (void)hide {
    if (!self.attachedView) {
        self.attachedView = [VVFrameWindow sharedWindow].attachView;
    }
    [self.attachedView hideBackground];

    [self hideAnimation];
}

- (void)showAnimation {
    if (!self.superview) {
        [self.attachedView.backgroundPopuView addSubview:self];
    }
    self.frame = CGRectMake((CGRectGetWidth(self.attachedView.frame) - CGRectGetWidth(self.frame)) * 0.5f, CGRectGetHeight(self.attachedView.frame) + CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

    VVWeakify(self);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         VVStrongify(self);
                         if (self.bottom) {
                             self.frame = CGRectMake((CGRectGetWidth(self.attachedView.frame) - CGRectGetWidth(self.frame)) * 0.5f, CGRectGetHeight(self.attachedView.frame) - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                         } else {
                             self.frame = CGRectMake((CGRectGetWidth(self.attachedView.frame) - CGRectGetWidth(self.frame)) * 0.5f, (CGRectGetHeight(self.attachedView.frame) - CGRectGetHeight(self.frame)) * 0.5f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                         }
                     }
                     completion:^(BOOL finished) {
                         VVStrongify(self);
                         if (self.becomeResponder && finished && self.fieldResponder) {
                             [self.fieldResponder becomeFirstResponder];
                         }
                     }];
}

- (void)hideAnimation {
    if (!self.superview) {
        [self removeFromSuperview];
        return;
    }

    if (self.fieldResponder) {
        [self.fieldResponder resignFirstResponder];
    }

    VVWeakify(self);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         VVStrongify(self);
                         self.frame = CGRectMake((CGRectGetWidth(self.attachedView.frame) - CGRectGetWidth(self.frame)) * 0.5f, CGRectGetHeight(self.attachedView.frame) + CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                     }

                     completion:^(BOOL finished) {
                         VVStrongify(self);
                         [self removeFromSuperview];
                         self.attachedView = nil;
                     }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.hasHideKeboard) {
        // get keyboard size and loctaion
        CGRect keyboardBounds;
        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
        self.keybordHeight = keyboardBounds.size.height;

        CGFloat oldY = self.frame.origin.y + self.frame.size.height;
        CGFloat newY = [UIScreen mainScreen].bounds.size.height - self.keybordHeight;
        if (self.openField && self.fieldResponder) {
            CGFloat fieldY = self.beforeY + CGRectGetMaxY(self.fieldResponder.frame);
            if (fieldY > newY) {
                self.afterY = self.beforeY - (fieldY - newY);
            } else {
                self.afterY = self.beforeY;
            }
        } else {
            if (self.bottom) {
                self.afterY = newY - self.frame.size.height;
            } else {
                if (oldY > newY) {
                    self.afterY = newY - self.frame.size.height;
                } else {
                    self.afterY = self.frame.origin.y;
                }
            }
        }
    }
    self.hasHideKeboard = NO;

    VVWeakify(self);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         VVStrongify(self);
                         CGRect frame = self.frame;
                         frame.origin.y = self.afterY;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.hasHideKeboard = YES;

    VVWeakify(self);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         VVStrongify(self);
                         CGRect frame = self.frame;
                         frame.origin.y = self.beforeY;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         VVStrongify(self);
                         if (finished) {
                             if (self.frame.origin.y >= [UIScreen mainScreen].bounds.size.height) {
                                 [self removeFromSuperview];
                                 self.attachedView = nil;
                             }
                         }
                     }];
}


- (void)actionTap:(UITapGestureRecognizer *)gesture {
    if (!self.attachedView.backgroundAnimating) {
        [self hide];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (touch.view == self.attachedView.backgroundPopuView);
}

@end
