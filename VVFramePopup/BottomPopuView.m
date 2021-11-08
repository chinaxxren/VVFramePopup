//
// Created by Tank on 2019-08-05.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "BottomPopuView.h"

@interface BottomPopuView()

@property(nonatomic,strong) UITextField *textField;

@end

@implementation BottomPopuView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 340, 500)];
    if (self) {
        self.bottom = NO;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 300, 320, 44)];
        self.textField.backgroundColor = [UIColor redColor];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.text = @"1234567890";
        [self addSubview:self.textField];
        
        self.fieldResponder = self.textField;
        self.openField = YES;
        self.becomeResponder = NO;
    }
    return self;
}

@end
