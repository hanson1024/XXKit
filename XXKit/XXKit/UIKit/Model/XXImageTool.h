//
//  XXImageTool.h
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXXImageToolSourceType) {
    YXXImageToolSourceTypePhoto = 0, //相册
    YXXImageToolSourceTypeCamera     //相机
};

typedef void(^DidFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);

@interface XXImageTool : NSObject

+ (instancetype)shareManager;

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;


/**
 打开相机或者相册
 
 @param type YXXImageToolSourceType
 @param maxImagesCount 选择相册时，图片最多选取数量
 @param finishPickingPhotosHandle 操作完成后回调BLOCK
 */
- (void )openMobileImagesWithType:(YXXImageToolSourceType )type maxImagesCount:(NSInteger )maxImagesCount finishBlock:(DidFinishPickingPhotosHandle )finishPickingPhotosHandle;

@end
