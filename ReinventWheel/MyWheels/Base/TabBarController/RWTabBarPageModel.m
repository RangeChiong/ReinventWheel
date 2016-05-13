//
//  RWTabBarPageModel.m
//  ReinventWheel
//
//  Created by Ranger on 16/5/13.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWTabBarPageModel.h"
#import "RWShowModuleController.h"
#import "RWShowHelperController.h"
#import "RWShowCategoryController.h"

@interface RWTabBarPageModel () {
    NSArray *_classes;
    NSArray *_titles;
    NSArray *_selectedImages;
    NSArray *_unselectedImages;
}

@end

@implementation RWTabBarPageModel

@synthesize controllers = _controllers;

- (NSArray *)controllers {
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIViewController *controller = [[self.classes[i] alloc] init];
            controller.title = _titles[i];
            
            UIImage *image = [self.unselectedImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectedImage = [self.selectedImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:_titles[i]
                                                                  image:image
                                                          selectedImage:selectedImage];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            
            [controllers addObject:nav];
        }
        
        _controllers = controllers.copy;
    }
    return _controllers;
}

- (NSArray *)classes {
    if (!_classes) {
        _classes = @[
                     [RWShowModuleController class],
                     [RWShowHelperController class],
                     [RWShowCategoryController class]
                     ];
    }
    return _classes;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"模块",
                    @"快捷工具",
                    @"分类",
                    ];
    }
    return _titles;
}

- (NSArray *)selectedImages {
    if (!_selectedImages) {
        NSMutableArray *selectedImages = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_selected_%d", i]];
            [selectedImages addObject:img];
        }
        _selectedImages = selectedImages.copy;
    }
    return _selectedImages;
}

- (NSArray *)unselectedImages {
    if (!_unselectedImages) {
        NSMutableArray *unselectedImages = [NSMutableArray new];
        for (int i = 0; i < self.titles.count; i ++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_unselected_%d", i]];
            [unselectedImages addObject:img];
        }
        _unselectedImages = unselectedImages.copy;
    }
    return _unselectedImages;
}

@end
