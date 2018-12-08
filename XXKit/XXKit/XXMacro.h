//
//  XXMacro.h
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

#import "NSDictionary+Common.h"

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

//字体
#define FONT(F_S)                               [UIFont systemFontOfSize:(F_S)]
#define BOLD_FONT(F_S)                          [UIFont boldSystemFontOfSize:(F_S)]

//判断可用的NSObject对象
#define IS_AVAILABLE_OBJ(NSSET_OBJ)             (NSSET_OBJ != nil)
#define IS_AVAILABLE_NSSET_OBJ(NSSET_OBJ)       (NSSET_OBJ != nil && NSSET_OBJ.count > 0)
#define IS_AVAILABLE_NSSTRNG(STRING)            (STRING != nil && [STRING isKindOfClass:[NSString class]] && STRING.length > 0)
#define IS_AVAILABLE_ATTRIBUTEDSTRING(ATTR_STR) (ATTR_STR != nil && ATTR_STR.length > 0)
#define IS_AVAILABLE_DATA(DATA)                 (DATA != nil && DATA.length > 0)
#define IS_AVAILABLE_ARRAY(LIST)                (LIST != nil && [LIST isKindOfClass:[NSArray class]])
#define IS_AVAILABLE_DICT(DICTIONARY)           (DICTIONARY != nil && [DICTIONARY isKindOfClass:[NSDictionary class]])

#define IS_IN_ARRAY_FOR_INDEX(ARRAY,INDEX)      (IS_AVAILABLE_NSSET_OBJ(ARRAY) ? (INDEX >= 0 && INDEX < ARRAY.count) : NO)

//返回的一些安全操作
#define NSSTRING_SAFE_GET_NONULL_VAL(VAL)       (VAL) ? (VAL) : @""
#define NSSTRING_SAFE_RET_NONULL_VAL(VAL)       return ((VAL) ? (VAL) : @"")
#define NSSTRING_SAFE_GET_NOnull_VAL(VAL)       (([VAL isEqual:[NSNull null]]) ? @"": VAL)

#define NSNUMBER_SAFE_GET_NONULL_VAL(VAL)       (([VAL isEqual:[NSNull null]]) ? @0: VAL)

#define NSARRAY_SAFE_GET_NONULL_VAL(VAL)        (VAL) ? (VAL) : (@[])
#define NSARRAY_SAFE_RET_NONULL_VAL(VAL)        return ((VAL) ? (VAL) : (@[]))

#define NSDICTIONARY_SAFE_GET_NONULL_VAL(VAL)   (VAL) ? (VAL) : (@{})
#define NSDICTIONARY_SAFE_RET_NONULL_VAL(VAL)   return ((VAL) ? (VAL) : (@{}))

//弱引用
#define WEAK_NSOBJ(NSOBJ,WEAK_NAME)             __weak __typeof(&*NSOBJ) WEAK_NAME = NSOBJ
#define WEAK_SELF(WEAK_NAME)                    __weak __typeof(&*self) WEAK_NAME = self

#define nPresentViewController                   @"nPresentViewController"    //全局弹出VC
#define PresentViewControllerParamsKey           @"PresentViewControllerParamsKey"

#endif /* XXMacro_h */
