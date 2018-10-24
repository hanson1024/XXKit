//
//  UIButton+Common.h
//  contact
//
//  Created by luo on 2018/7/10.
//  Copyright © 2018年 momo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>

#define kColorBlue      UIColorHex(0x388cff)
#define kColorRed       UIColorHex(0xf2266f)
#define kColorOrange    UIColorHex(0xfda844)
#define kColorGreen     UIColorHex(0x26b9d1)
#define kColorPurple    UIColorHex(0xb86adc)

typedef NS_ENUM(NSInteger, CustomButtonType) {
    CustomButtonTypeDefault = 0,                 //系统默认
    CustomButtonTypeBigCorner,                   //高度0.5圆角
    CustomButtonTypeSmallCorner,                 //5 圆角
    CustomButtonTypeBigCornerAndColor,           //高度0.5圆角，带有kColorBlue颜色
    CustomButtonTypeSmallCornerAndColor,         //5 圆角，带有kColorBlue颜色
    CustomButtonTypeBigCornerAndGradient,        //高度0.5圆角，渐变颜色
    CustomButtonTypeSmallCornerAndGradient       //5 圆角，渐变颜色
};

typedef void(^UIButtonActionBlock)();


@interface UIButton (Common)

-(void)defaultStyle;
-(void)bigCornerStyle;
-(void)smallCornerStyle;
-(void)bigCornerAndColorStyle;
-(void)smallCornerAndColorStyle;
-(void)bigCornerAndGradientStyle;
-(void)smallCornerAndGradientStyle;

+ (UIButton *)buttonWithStyle:(CustomButtonType)style andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock;
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andBackColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock;
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andCornerColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock;

+ (UIButton *)buttonWithStyle:(CustomButtonType)style andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector;
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andBackColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector;
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andCornerColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector;

////////////////////////////////////////////////////////////////////////////////////////////////


-(void)setSafeImageWithNormalImage:(NSString *)normalStr select:(NSString *)selectStr;
-(void)setSafeStringWithNormalString:(NSString *)normalStr select:(NSString *)selectStr;
-(void)setSafeColorWithNormalColor:(UIColor *)normalColor select:(UIColor *)selectColor;


////////////////////////////////////////////////////////////////////////////////////////////////


/** 扩张边界大小 */
@property (nonatomic, assign) CGFloat enlargedEdge;

-(void)setEnlargedEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
