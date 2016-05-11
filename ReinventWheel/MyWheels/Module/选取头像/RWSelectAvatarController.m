//
//  RWSelectAvatarController.m
//  Test1208
//
//  Created by 常小哲 on 15/12/8.
//  Copyright © 2015年 常小哲. All rights reserved.
//

#import "RWSelectAvatarController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface RWSelectAvatarController ()<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate> {
    
    void(^_takePictureBlock)(UIImage *selectedImage);
}

@property (nonatomic, strong) UIActionSheet *actionSheet;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;
- (void)showForPicture:(void(^)(UIImage *selectedImage))block;

@end

@implementation RWSelectAvatarController

#pragma mark-  public methods

+ (instancetype)showWithController:(UIViewController *)controller takePicture:(void(^)(UIImage *editedImage))block {
    RWSelectAvatarController *ctrl = [[RWSelectAvatarController alloc] initWithController:controller];
    [ctrl showForPicture:block];
    return ctrl;
}

+ (instancetype)showWithController:(UIViewController *)controller {
    RWSelectAvatarController *ctrl = [[RWSelectAvatarController alloc] initWithController:controller];
    [ctrl show];
    
    return ctrl;
}

#pragma mark-  private methods

- (instancetype)initWithController:(UIViewController *)controller {
    if (self == [super init]) {
        [self addToController:controller];
    }
    return self;
}

- (void)show {
    [self.actionSheet showInView:self.view];
}

- (void)showForPicture:(void(^)(UIImage *selectedImage))block {
    [self show];
    _takePictureBlock = ^(UIImage *selectedImage) {
        block(selectedImage);
    };
}

#pragma mark-  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != 10086) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    switch (buttonIndex) {
            // 相机
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                NSLog(@"相机功能不可用");
                return;
            }
        }
            // 图库
        case 1: {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
            // 取消
        case 2: {
            [self removeFromController];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(takeOriginalSelectedPicture:)]) {
            [_delegate takeOriginalSelectedPicture:originalImage];
        }
        
        if ([_delegate respondsToSelector:@selector(takeEditedSelectedPicture:)]) {
            [_delegate takeEditedSelectedPicture:editedImage];
        }
    }else {
        _takePictureBlock(editedImage);
    }
    
    [self removeFromController];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self removeFromController];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-  utils

- (void)addToController:(UIViewController *)controller {
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
}

- (void)removeFromController {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark-   Setter & Getter

- (UIActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"我的相册", nil];
        _actionSheet.tag = 10086;
        _actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    return _actionSheet;
}

@end

#pragma clang diagnostic pop

