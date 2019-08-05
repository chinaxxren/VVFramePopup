//
// Created by Tank on 2019-08-05.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "BottomPopuView.h"


@implementation BottomPopuView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320.0f, 200.0f)];
    if (self) {
        self.bottom = NO;
    }
    return self;
}

@end
