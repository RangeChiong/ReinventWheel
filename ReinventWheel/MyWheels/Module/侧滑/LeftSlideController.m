//
//  LeftSlideController.m
//  Test0422
//
//  Created by Ranger on 16/4/22.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "LeftSlideController.h"
#import "LeftSortsViewController.h"

#define kSpeedFloat         0.7   //滑动速度
#define kMainPageScale      1.0   //打开左侧窗时，中视图(右视图）缩放比例

#define kLeftAlpha   0.9  //左侧蒙版的最大值
#define kLeftCenterX 30   //左侧初始偏移量
#define kLeftScale   1.0  //左侧初始缩放比例


@interface LeftSlideController ()<UIGestureRecognizerDelegate> {
    
    LeftSortsViewController *_leftVC;
    UIViewController *_mainVC;

    CGFloat _moveDisance;   //!< 横移距离
    CGFloat _mainPageDistance; //!< 侧滑时，右视图露出的宽度 也是leftVC中tableView的X坐标
    BOOL _closed;   //!< 侧边栏的开关
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIView *leftMaskView;

@end

@implementation LeftSlideController

- (instancetype)initWithLeftViewController:(LeftSortsViewController *)leftVC
                        mainViewController:(UIViewController *)mainVC {
    if (self == [super init]) {
        _speed = kSpeedFloat;
        _mainPageDistance = leftVC.tableView.x;
        _closed = YES;
        
        _leftVC = leftVC;
        [_leftVC.view addSubview:self.leftMaskView];
        [self.view addSubview:_leftVC.view];
        
        _mainVC = mainVC;
        _mainVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _mainVC.view.layer.shadowOffset = CGSizeMake(-3, 0);
        _mainVC.view.layer.shadowOpacity = 0.5;
        _mainVC.view.layer.shadowRadius = 3;
        [_mainVC.view addGestureRecognizer:self.panGesture];
        [self.view addSubview:_mainVC.view];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark-   touch action

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    _moveDisance = (point.x * _speed + _moveDisance);

    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    
    if (((_mainVC.view.x <= 0) && (_moveDisance <= 0)) ||
        ((_mainVC.view.x >= (Screen_Width - _mainPageDistance )) && (_moveDisance >= 0))) {
        
        //边界值管控
//        _moveDisance = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (pan.view.x >= 0) && (pan.view.x <= (Screen_Width - _mainPageDistance))) {
       
        CGFloat centerX = pan.view.center.x + point.x * _speed;
        if (centerX < Screen_Width / 2 - 2) {
            centerX = Screen_Width / 2;
        }
        pan.view.centerX = centerX;
        
        //scale 1.0~kMainPageScale
        CGFloat scale = 1 - (1 - kMainPageScale) * (pan.view.x / (Screen_Width - _mainPageDistance));
        pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [pan setTranslation:CGPointZero inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((Screen_Width - _mainPageDistance) / 2 - kLeftCenterX) * (pan.view.x / (Screen_Width - _mainPageDistance));
        _leftVC.tableView.center = CGPointMake(leftTabCenterX, Screen_Height / 2);
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (pan.view.x / (Screen_Width - _mainPageDistance));
        _leftVC.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (pan.view.x  / (Screen_Width - _mainPageDistance));
        _leftMaskView.alpha = tempAlpha;
        
    } else {
        //超出范围，
        if (_mainVC.view.x < 0) {
            [self closeLeftView];
//            _moveDisance = 0;
        }
        else if (_mainVC.view.x > (Screen_Width - _mainPageDistance)) {
            [self openLeftView];
//            _moveDisance = 0;
        }
        _moveDisance = 0;

    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (fabs(_moveDisance) > (Screen_Width - _mainPageDistance) / 2 - kLeftCenterX) {
            if (_closed) {
                [self openLeftView];
            }
            else {
                [self closeLeftView];
            }
        }
        else {
            if (_closed)  {
                [self closeLeftView];
            }
            else {
                [self openLeftView];
            }
        }
        _moveDisance = 0;
    }
}

#pragma mark - 单击手势
- (void)handeTap:(UITapGestureRecognizer *)tap {
    
    if ((!_closed) && (tap.state == UIGestureRecognizerStateEnded)) {
        [self resetContentView];
    }
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView {
    [self resetContentView];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView {
    [UIView animateWithDuration:0.2 animations:^{
        _mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
        _mainVC.view.center = CGPointMake(Screen_Width + Screen_Width * kMainPageScale / 2 - _mainPageDistance, Screen_Height / 2) ;
        _closed = NO;
        
        _leftVC.tableView.center = CGPointMake((Screen_Width - _mainPageDistance) / 2, Screen_Height / 2);
        _leftVC.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        _leftMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        if (!_tapGesture) {
            [_mainVC.view addGestureRecognizer:self.tapGesture];
        }
    }];
}

//关闭行为收敛
- (void)removeSingleTap {
    [_mainVC.view removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
}

//重置主视图和左视图
- (void)resetContentView {
    [UIView animateWithDuration:0.2 animations:^{
        _mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        _mainVC.view.center = CGPointMake(Screen_Width / 2, Screen_Height / 2);
        _closed = YES;
        
        _leftVC.tableView.center = CGPointMake(kLeftCenterX, Screen_Height / 2);
        _leftVC.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
        _leftMaskView.alpha = kLeftAlpha;
        
    } completion:^(BOOL finished) {
        _moveDisance = 0;
        [self removeSingleTap];
    }];
}

#pragma mark-   Setter & Getter

- (void)setPanEnabled:(BOOL)panEnabled {
    _panEnabled = panEnabled;
    self.panGesture.enabled = panEnabled;
    
    if (panEnabled) {
        _leftVC.view.hidden = NO;
    }else {
        _leftVC.view.hidden = YES;
    }
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePanGesture:)];
        
        [_panGesture setCancelsTouchesInView:YES];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(handeTap:)];
        [_tapGesture setNumberOfTapsRequired:1];
        _tapGesture.cancelsTouchesInView = YES;
     }
    return _tapGesture;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc] initWithFrame:_leftVC.view.bounds];
        _leftMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    return _leftMaskView;
}

@end
