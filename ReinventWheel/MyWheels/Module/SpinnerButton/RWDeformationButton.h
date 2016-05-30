//
//  RWDeformationButton.h
//  RWButton
//
//  Created by Ranger on 16/5/30.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWSpinner.h"

@interface RWDeformationButton : UIControl

@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, strong) RWSpinner *spinnerView;
@property(nonatomic, strong) UIColor *contentColor;
@property(nonatomic, strong) UIColor *progressColor;

@property(nonatomic, strong) UIButton *forDisplayButton;


@end
