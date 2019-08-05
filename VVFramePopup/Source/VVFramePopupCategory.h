//
// Created by Tank on 2019-08-01.
// Copyright (c) 2019 Jiangmingz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (Popup)

@property(nonatomic, strong, readonly) UIView *backgroundPopuView;
@property(nonatomic, assign) BOOL backgroundAnimating;
@property(nonatomic, assign) NSInteger referenceCount;

- (void)showBackground;

- (void)hideBackground;

@end