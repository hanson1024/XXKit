//
//  XXImageTool.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXImageTool.h"
#import "XXMacro.h"

#import <TZImagePickerController.h>

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface XXImageTool ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** <#注释#> */
@property (nonatomic, copy) DidFinishPickingPhotosHandle finishBlock;

@end

@implementation XXImageTool

+(instancetype)shareManager {
    
    static XXImageTool *coder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coder = [[XXImageTool alloc] init];
    });
    return coder;
}

+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    
    NSLog(@"%@", tipStr);
}

- (void )openMobileImagesWithType:(YXXImageToolSourceType )type maxImagesCount:(NSInteger )maxImagesCount finishBlock:(DidFinishPickingPhotosHandle )finishPickingPhotosHandle{
    
    if (YXXImageToolSourceTypePhoto == type) {
        
        if (![XXImageTool checkPhotoLibraryAuthorizationStatus]) {
            return ;
        }
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:self];
        imagePickerVc.naviBgColor = [UIColor orangeColor];
        imagePickerVc.iconThemeColor = [UIColor orangeColor];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor orangeColor];
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            !finishPickingPhotosHandle?:finishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:nPresentViewController object:@{PresentViewControllerParamsKey:imagePickerVc}];
        
    }else if (YXXImageToolSourceTypeCamera == type) {
        
        if (![XXImageTool checkCameraAuthorizationStatus]) {
            return ;
        }
        
        self.finishBlock = finishPickingPhotosHandle;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[NSNotificationCenter defaultCenter] postNotificationName:nPresentViewController object:@{PresentViewControllerParamsKey:picker}];
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && originalImage) {
        
        WEAK_SELF(weakSelf);
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetLibrary writeImageToSavedPhotosAlbum:originalImage.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            [assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                if (asset) {
                    NSArray *photos = @[originalImage];
                    NSArray *assets = @[asset];
                    
                    !weakSelf.finishBlock?:weakSelf.finishBlock(photos,assets,YES);
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
