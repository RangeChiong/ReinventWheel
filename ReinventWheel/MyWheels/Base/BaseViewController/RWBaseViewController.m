//
//  RWBaseViewController.m
//  ReinventWheel
//
//  Created by 常小哲 on 16/5/11.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWBaseViewController.h"

@interface RWBaseViewController ()

@end

@implementation RWBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _enablePanGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

}


@end
