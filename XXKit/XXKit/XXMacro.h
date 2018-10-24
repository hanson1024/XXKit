//
//  XXMacro.h
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

#ifndef XXMacro_h
#define XXMacro_h

#define STATUS_BAR_HEIGHT                      [[UIApplication sharedApplication] statusBarFrame].size.height
#define CONST_NAV_BAR_HEIGHT                   (44)


#define SAFE_INSETS                            (AVAILABLE_IOS_11 ? [[UIApplication sharedApplication].windows firstObject].safeAreaInsets : UIEdgeInsetsZero)

#define SAFE_X                                 (AVAILABLE_IOS_11 ? SAFE_INSETS.left : 0)
#define SAFE_Y                                 (AVAILABLE_IOS_11 ? SAFE_INSETS.top : 0)
#define SAFE_BOTTOM                            (AVAILABLE_IOS_11 ? SAFE_INSETS.bottom : 0)
#define SAFE_RIGHT                             (AVAILABLE_IOS_11 ? SAFE_INSETS.right : 0)

#define AVAILABLE_IOS_V(IOS_V)                 ({ \
BOOL OK = NO; \
if(@available(iOS IOS_V,*)) \
OK = YES; \
OK; \
})
#define AVAILABLE_IOS_11                        AVAILABLE_IOS_V(11.0)

#define SCREEN_BOUNDS                          [UIScreen mainScreen].bounds
#define SCREEN_SCALE                           [UIScreen mainScreen].scale

#define SCREEN_WIDTH                           [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                          [UIScreen mainScreen].bounds.size.height

//弱引用
#define WEAK_NSOBJ(NSOBJ,WEAK_NAME)             __weak __typeof(&*NSOBJ) WEAK_NAME = NSOBJ
#define WEAK_SELF(WEAK_NAME)                    __weak __typeof(&*self) WEAK_NAME = self

#define nPresentViewController                   @"nPresentViewController"    //全局弹出VC


#define PresentViewControllerParamsKey @"PresentViewControllerParamsKey"

#endif /* XXMacro_h */
