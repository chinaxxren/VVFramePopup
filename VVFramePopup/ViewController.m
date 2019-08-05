//
//  ViewController.m
//  VVFramePopup
//
//  Created by Tank on 2019/8/5.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "VVFramePopupView.h"
#import "BottomPopuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 44.0f)];
    [button setBackgroundColor:[UIColor redColor]];
    button.center = self.view.center;
    [button addTarget:self action:@selector(clickRed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickRed {
    BottomPopuView *bottomPopuView = [BottomPopuView new];
    [bottomPopuView show];
}

@end
