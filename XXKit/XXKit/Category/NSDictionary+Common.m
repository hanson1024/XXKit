//
//  NSDictionary+Common.m
//  XXKit
//
//  Created by luo on 2018/12/8.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)

+ (NSDictionary *)dictionnayWithContentsOfFileName:(NSString *)fileName {
    
    if (!fileName || ![fileName length]) return nil;
    
    NSString *content            = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    NSData *data                 = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *receiveStr         = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData             = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        return nil;
    }else {
        return responseObject;
    }
}

@end
