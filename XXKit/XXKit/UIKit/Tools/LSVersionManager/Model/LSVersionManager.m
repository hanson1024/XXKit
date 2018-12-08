//
//  LSVersionManager.m
//  contact
//
//  Created by luo on 2018/10/31.
//  Copyright © 2018年 gdtech. All rights reserved.
//

#import "LSVersionManager.h"
#import "LSVersionUpdateView.h"

static NSString *const kUpdateTipData  = @"ls_versionUpdate_updateTipData";
static NSString *const kTotalNumber    = @"ls_versionUpdate_totalNumber";
static NSString *const kUpdateNumber   = @"ls_versionUpdate_updateNumber";
static NSString *const kRemoveTipKey   = @"ls_versionUpdate_removeTipKey";

#define kVersionKey(version) [NSString stringWithFormat:@"%@%@",kUpdateTipData,version]

#define APP_URL @"https://itunes.apple.com/cn/app/id2423446776?mt=8"

@implementation LSVersionManager

+ (void)checkAppVersionDataWithForce:(BOOL)isForce {
        
    //本地数据测试
    
    NSDictionary *responseObject = [NSDictionary dictionnayWithContentsOfFileName:@"test.txt"];
        
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *currentVersionStr = [NSString stringWithFormat:@"当前版本：V%@",currentVersion];
    
    if (IS_AVAILABLE_DICT(responseObject)) {
        
        NSString *versionName = NSSTRING_SAFE_GET_NONULL_VAL([responseObject objectForKey:@"versionName"]);
        NSString *forceUpdateVer = NSSTRING_SAFE_GET_NONULL_VAL([responseObject objectForKey:@"forceUpdateVer"]);
        long updatePrompt = [[responseObject objectForKey:@"updatePrompt"] longValue];
        NSArray *updateContent = [responseObject objectForKey:@"updateContent"];
        
        BOOL hasUpdate = [self compareVersionWithNewVersion:versionName currentVersion:currentVersion]; //是否升级
        BOOL hasForceUpdate = [self compareVersionWithNewVersion:forceUpdateVer currentVersion:currentVersion]; //是否强制升级
        
        if (!hasForceUpdate) {
            
            if (!hasUpdate) return ; //新的版本号等于或者小于当前版本号，则不需提示
            if (isForce) return; //APP进入前台，且需要强制更新，才提示
            if ([self hasRemoveTipForVersion:versionName]) return; //校验是否勾选过跳过版本更新
            if ([self hasMaxTipCountForVersion:versionName]) return; //是否已经超过最大提示次数
        }
        
        if (IS_AVAILABLE_ARRAY(updateContent) && [updateContent count]) {
            NSLog(@"updateContent = %@",updateContent);
        }else {
            NSLog(@"无提示文案");
            updateContent = [NSArray array];
        }
        
        LSVersionUpdateView *updateVersionView = [LSVersionUpdateView showUpdateWithTitles:updateContent versionStr:currentVersionStr newVersionStr:versionName force:hasForceUpdate];
        [updateVersionView setDidClickUpdateButtonBlock:^(NSInteger idx) {
            if (idx == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_URL]];
            }
            
            if (idx == 2) {
                NSLog(@"跳过本次更新");
                [self saveRemoveTipForVersion:versionName];
            }
            
            if (idx == 0) {
                [self saveVersionTipCount:updatePrompt forVersion:versionName];
            }
        }];
        
        [updateVersionView showInView:[UIApplication sharedApplication].keyWindow];
    }
  
}


/**
 校验版本大小
 
 @param newVersion 新的版本号
 @param currentVersion 当前版本号
 @return newVersion > currentVersion 返回YES 否则返回NO
 */
+ (BOOL)compareVersionWithNewVersion:(NSString *)newVersion currentVersion:(NSString *)currentVersion {
    
    if (!IS_AVAILABLE_NSSTRNG(newVersion)) {
        return NO;
    }
    
    if (!IS_AVAILABLE_NSSTRNG(currentVersion)) {
        return NO;
    }
    
    NSArray *versionArray = [newVersion componentsSeparatedByString:@"."];//服务器返回版
    NSArray *currentVesionArray = [currentVersion componentsSeparatedByString:@"."];//当前版本
    
    BOOL hasUpdate = NO;
    if (currentVesionArray.count > versionArray.count) {
        hasUpdate = NO;
    } else if (currentVesionArray.count < versionArray.count){
        hasUpdate = YES;
    } else {
        hasUpdate = NO;
    }
    
    NSInteger count = versionArray.count < currentVesionArray.count ? versionArray.count : currentVesionArray.count;
    
    for (int i = 0; i < count; i++) {
        NSInteger a = [[versionArray objectAtIndex:i] integerValue];
        NSInteger b = [[currentVesionArray objectAtIndex:i] integerValue];
        if (a > b) {
            hasUpdate = YES;
            break;
        }else if (a < b){
            hasUpdate = NO;
            break;
        }else {
            continue;
        }
    }
    
    return hasUpdate;
}


/**
 是否超过最大提示数量

 @param version 对应的版本
 @return yes 是  no 否
 */
+ (BOOL )hasMaxTipCountForVersion:(NSString *)version {
    
    if (!IS_AVAILABLE_NSSTRNG(version)) {
        return NO;
    }
    
    NSMutableDictionary *params = [self getParamsForVersion:version];
    
    NSNumber *hasCount = [params objectForKey:kUpdateNumber];
    
    if (hasCount) {
        long count = [hasCount longValue];
        return count < 1 ? YES : NO;
    } else {
        return NO;
    }
}


/**
 保存最大提示的数量

 @param count 对应的版本的最多提示次数
 @param version 对应的版本
 */
+ (void)saveVersionTipCount:(long )count forVersion:(NSString *)version {
    
    if (!IS_AVAILABLE_NSSTRNG(version)) {
        return;
    }
    
    NSMutableDictionary *hasCountDict = [self getParamsForVersion:version];
    
    NSNumber *hasCount = [hasCountDict objectForKey:kUpdateNumber];
    
    if (hasCount) {
        long localCount = [hasCount longValue];
        localCount --;
        if (localCount < 0) {
            localCount = 0;
        }
        [hasCountDict setObject:[NSNumber numberWithLong:localCount] forKey:kUpdateNumber];
    } else {
        count --;
        if (count < 0) {
            count = 0;
        }
        [hasCountDict setObject:[NSNumber numberWithLong:count] forKey:kUpdateNumber];
    }
    
    [self saveParams:hasCountDict ForVersion:version];
}


/**
 勾选跳过当前版本

 @param version 对应的版本
 */
+ (void)saveRemoveTipForVersion:(NSString *)version {
    
    NSMutableDictionary *params = [self getParamsForVersion:version];
    
    [params setObject:[NSNumber numberWithBool:YES] forKey:kRemoveTipKey];
    
    [self saveParams:params ForVersion:version];
}


/**
 判断当前版本是否勾选过跳过提示更新

 @param version 版本信息
 @return YES NO
 */
+ (BOOL )hasRemoveTipForVersion:(NSString *)version {
    
    if (!IS_AVAILABLE_NSSTRNG(version)) {
        return NO;
    }
    
    NSMutableDictionary *params = [self getParamsForVersion:version];
    
    NSNumber *hasRemove         = [params objectForKey:kRemoveTipKey];
    
    return hasRemove            == nil ? NO : YES;
    
}


/**
 获取当前版本对应的参数

 @param version 版本信息
 @return 对应的参数
 */
+ (NSMutableDictionary *)getParamsForVersion:(NSString *)version {
    
    if (!IS_AVAILABLE_NSSTRNG(version)) {
        return nil;
    }
    
    NSDictionary *versionsDict    = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateTipData];
    NSMutableDictionary *TPDict   = [NSMutableDictionary dictionaryWithDictionary:versionsDict ? versionsDict : [NSDictionary dictionary]];
    
    NSDictionary *TPhasCountDict  = [TPDict objectForKey:kVersionKey(version)];
    return [NSMutableDictionary dictionaryWithDictionary:TPhasCountDict ? TPhasCountDict : [NSDictionary dictionary]];
}


/**
 保存当前版本对应的参数

 @param parmas 对应的参数
 @param version 版本信息
 */
+ (void)saveParams:(NSDictionary *)parmas ForVersion:(NSString *)version {
    
    if (!IS_AVAILABLE_NSSTRNG(version)) {
        return ;
    }
    
    if (!IS_AVAILABLE_DICT(parmas)) {
        return ;
    }
    
    NSDictionary *versionsDict  = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateTipData];
    NSMutableDictionary *TPDict = [NSMutableDictionary dictionaryWithDictionary:versionsDict ? versionsDict : [NSDictionary dictionary]];
    [TPDict setObject:parmas forKey:kVersionKey(version)];
    [[NSUserDefaults standardUserDefaults] setObject:TPDict forKey:kUpdateTipData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL )hasOneDay {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateTipData];
    
    if (dict) {
        
        NSDate *currentDate = [NSDate date];
        NSDate *lastTipDate = [dict objectForKey:@"lastTipDate"];
        NSTimeInterval time = [currentDate timeIntervalSinceDate:lastTipDate];
        NSInteger days = ((int)time)/(3600*24);
        
        if (days > 0) {
            return YES;
        } else {
            return NO;
        }
        
    } else {
        return YES;
    }
}

+ (NSString *)pathOfSTPlist{
    return [[self downloadPath] stringByAppendingPathComponent:@"GDOA_VERSIONS.plist"];
}

+ (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"GDOA_versions"];
    return downloadPath;
}

@end
