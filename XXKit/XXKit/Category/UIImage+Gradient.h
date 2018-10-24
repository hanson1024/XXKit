//
//  UIImage+Gradient.h
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom          = 0,   //从上到小
    GradientTypeLeftToRight          = 1,   //从左到右
    GradientTypeUpleftToLowright     = 2,   //左上到右下
    GradientTypeUprightToLowleft     = 3,   //右上到左下
    
};

@interface UIImage (Gradient)

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end
