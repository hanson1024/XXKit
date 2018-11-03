//
//  LSVersionManager.h
//  contact
//
//  Created by luo on 2018/10/31.
//  Copyright © 2018年 gdtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSVersionManager : NSObject

/**
 检查APP是否需要更新
 
 @param isForce YES 只有强制更新才提示
 */
+ (void)checkAppVersionDataWithForce:(BOOL )isForce;

@end
