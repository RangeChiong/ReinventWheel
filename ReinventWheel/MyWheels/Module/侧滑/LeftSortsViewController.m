//
//  LeftSortsViewController.m
//  Test0422
//
//  Created by Ranger on 16/4/22.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "LeftSlideController.h"
#import "AppDelegate.h"

@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSArray *tipImages;
@property (nonatomic, strong) NSArray *tipTitles;

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tipTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tipTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = _tipTitles[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
//    [tempAppDelegate.leftSlideController closeLeftView];//关闭左侧抽屉
//
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}


#pragma mark-   Setter & Getter

- (NSArray *)tipImages {
    if (!_tipImages) {
        _tipImages = @[];
    }
    return _tipImages;
}

- (NSArray *)tipTitles {
    if (!_tipTitles) {
        _tipTitles = @[
                       @[
                           @"出售房源",
                           @"出租房源",
                           @"约看房源"
                           ],
                       @[
                           @"我的房源",
                           @"钥匙管理"
                           ],
                       @[
                           @"我的客源",
                           @"抢公房",
                           @"抢公客",
                           ],
                       @[
                           @"输PIN码",
                           @"扫一扫",
                           ],
                       @[
                           @"我的提醒",
                           ]
                       ];
    }
    return _tipTitles;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_showRightViewWidth,
                                                                   0,
                                                                   Screen_Width - _showRightViewWidth,
                                                                   Screen_Height)
                                                  style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 49)];
        _tableView.sectionFooterHeight = 5.0;
        _tableView.sectionHeaderHeight = 5.0;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:Image_Named(@"leftbackiamge")];
        _bgImageView.frame = self.view.bounds;
    }
    return _bgImageView;
}

@end
