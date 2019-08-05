//
// Created by Tank on 2019-08-01.
// Copyright (c) 2019 Jiangmingz. All rights reserved.
//


#import "VVFramePopupCategory.h"

#import <objc/runtime.h>

#import "VVFrameWindow.h"

static const void *referenceCountKey = &referenceCountKey;
static const void *backgroundViewKey = &backgroundViewKey;
static const void *backgroundAnimatingKey = &backgroundAnimatingKey;

@implementation UIView (Popup)

@dynamic backgroundPopuView;
@dynamic backgroundAnimating;
@dynamic referenceCount;

- (UIView *)backgroundPopuView {
    UIView *view = objc_getAssociatedObject(self, backgroundViewKey);
    if (!view) {
        view = [UIView new];
        [self addSubview:view];
        view.frame = self.bounds;
        view.alpha = 0.0f;
        view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
        view.layer.zPosition = FLT_MAX;

        objc_setAssociatedObject(self, backgroundViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return view;
}

- (BOOL)backgroundAnimating {
    return [objc_getAssociatedObject(self, backgroundAnimatingKey) boolValue];
}

- (void)setBackgroundAnimating:(BOOL)backgroundAnimating {
    objc_setAssociatedObject(self, backgroundAnimatingKey, @(backgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)referenceCount {
    return [objc_getAssociatedObject(self, referenceCountKey) integerValue];
}

- (void)setReferenceCount:(NSInteger)referenceCount {
    objc_setAssociatedObject(self, referenceCountKey, @(referenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showBackground {
    ++self.referenceCount;

    if (self.referenceCount > 1) {
        return;
    }

    self.backgroundPopuView.hidden = NO;
    self.backgroundAnimating = YES;

    if (self == [VVFrameWindow sharedWindow].attachView) {
        [VVFrameWindow sharedWindow].hidden = NO;
        [[VVFrameWindow sharedWindow] makeKeyAndVisible];
    } else if ([self isKindOfClass:[UIWindow class]]) {
        self.hidden = NO;
        [(UIWindow *) self makeKeyAndVisible];
    } else {
        [self bringSubviewToFront:self.backgroundPopuView];
    }

    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundPopuView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                if (finished) {
                    self.backgroundAnimating = NO;
                }
            }];
}

- (void)hideBackground {
    --self.referenceCount;

    if (self.referenceCount > 0) {
        return;
    }

    self.backgroundAnimating = YES;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundPopuView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                if (finished) {
                    self.backgroundAnimating = NO;

                    if (self == [VVFrameWindow sharedWindow].attachView) {
                        [VVFrameWindow sharedWindow].hidden = YES;
                        [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                    } else if (self == [VVFrameWindow sharedWindow]) {
                        self.hidden = YES;
                        [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                    }
                }
            }];
}

@end
