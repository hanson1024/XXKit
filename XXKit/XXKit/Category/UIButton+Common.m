#import "UIButton+Common.h"
#import "UIImage+Gradient.h"

#import <objc/runtime.h>

static NSString *actionBlockKey = @"actionBlockKey";

@interface UIButton ()
//UI
/** <#注释#> */
@property (nonatomic, copy) UIButtonActionBlock actionBlock;

@end

@implementation UIButton (Common)

-(void)defaultStyle {
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

-(void)bigCornerStyle {
    
    [self settingBigCorner];
    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}

-(void)smallCornerStyle {
    [self settingSmallCorner];
    
    self.layer.borderColor = [[UIColor lightTextColor] CGColor];
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}

-(void)bigCornerAndColorStyle {
    
    [self settingBigCorner];
    
    
    
    self.layer.borderColor = [kColorBlue CGColor];
    self.backgroundColor = kColorBlue;
    [self setBackgroundImage:[self buttonImageFromColor:kColorBlue] forState:UIControlStateHighlighted];
}

-(void)smallCornerAndColorStyle {
    
    [self settingSmallCorner];
    
    self.layer.borderColor = [kColorBlue CGColor];
    self.backgroundColor = kColorBlue;
    [self setBackgroundImage:[self buttonImageFromColor:kColorBlue] forState:UIControlStateHighlighted];
}

-(void)bigCornerAndGradientStyle {
    
    [self settingBigCorner];
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    [self setBackgroundImage:[UIImage gradientColorImageFromColors:@[[UIColor colorWithHexString:@"#388cff"],[UIColor colorWithHexString:@"#1dc9fe"]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(480, 90)]  forState:0];
}

-(void)smallCornerAndGradientStyle {
    
    [self settingSmallCorner];
    self.layer.borderColor = [[UIColor clearColor] CGColor];
    [self setBackgroundImage:[UIImage gradientColorImageFromColors:@[[UIColor colorWithHexString:@"#388cff"],[UIColor colorWithHexString:@"#1dc9fe"]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(480, 90)]  forState:0];
}

-(void)settingBigCorner {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.layer.masksToBounds = YES;
}

-(void)settingSmallCorner {
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (UIImage *)buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIButton *)buttonWithStyle:(CustomButtonType)style andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    btn.actionBlock = actionBlock;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickWithButton:) forControlEvents:UIControlEventTouchUpInside];
    const  SEL selArray[] = {@selector(defaultStyle), @selector(bigCornerStyle), @selector(smallCornerStyle), @selector(bigCornerAndColorStyle), @selector(smallCornerAndColorStyle), @selector(bigCornerAndGradientStyle), @selector(smallCornerAndGradientStyle)};
    if ([btn respondsToSelector:selArray[style]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [btn performSelector:selArray[style]];
#pragma clang diagnostic pop
    }
    return btn;
}
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andBackColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock {
    
    UIButton *btn = [UIButton buttonWithStyle:style andTitle:title andFrame:rect actionBlock:actionBlock];
    btn.backgroundColor = color;
    btn.layer.borderColor = [color CGColor];
    
    return btn;
}
+ (UIButton *)buttonWithStyle:(CustomButtonType)style andCornerColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect actionBlock:(UIButtonActionBlock)actionBlock {
    
    UIButton *btn = [UIButton buttonWithStyle:style andTitle:title andFrame:rect actionBlock:actionBlock];
    btn.layer.borderColor = [color CGColor];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    return btn;
}


+ (UIButton *)buttonWithStyle:(CustomButtonType)style andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    const  SEL selArray[] = {@selector(defaultStyle), @selector(bigCornerStyle), @selector(smallCornerStyle), @selector(bigCornerAndColorStyle), @selector(smallCornerAndColorStyle), @selector(bigCornerAndGradientStyle), @selector(smallCornerAndGradientStyle)};
    if ([btn respondsToSelector:selArray[style]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [btn performSelector:selArray[style]];
#pragma clang diagnostic pop
    }
    return btn;
}

+ (UIButton *)buttonWithStyle:(CustomButtonType)style andBackColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector {
    
    UIButton *btn = [UIButton buttonWithStyle:style andTitle:title andFrame:rect target:target action:selector];
    btn.backgroundColor = color;
    btn.layer.borderColor = [color CGColor];
    
    return btn;
}

+ (UIButton *)buttonWithStyle:(CustomButtonType)style andCornerColor:(UIColor *)color andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector {
    
    UIButton *btn = [UIButton buttonWithStyle:style andTitle:title andFrame:rect target:target action:selector];
    btn.layer.borderColor = [color CGColor];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    return btn;
}

+(void)didClickWithButton:(UIButton *)button {
    
    if (button.actionBlock) {
        button.actionBlock();
    }
}

-(void)setActionBlock:(UIButtonActionBlock)actionBlock
{
    objc_setAssociatedObject(self, &actionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY);
}

-(UIButtonActionBlock)actionBlock
{
    return objc_getAssociatedObject(self, &actionBlockKey);
}

////////////////////////////////////////////////////////////////////////////////////////////////


-(void)setSafeImageWithNormalImage:(NSString *)normalStr select:(NSString *)selectStr{
    
    if (normalStr&&[normalStr length]>0) {
        [self  setImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
        [self  setImage:[UIImage imageNamed:normalStr] forState: UIControlStateHighlighted];
    }
    if (selectStr&&[selectStr length]>0) {
        [self  setImage:[UIImage imageNamed:selectStr] forState:UIControlStateSelected];
        [self  setImage:[UIImage imageNamed:selectStr] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    
    
}

-(void)setSafeStringWithNormalString:(NSString *)normalStr select:(NSString *)selectStr{
    
    if (normalStr&&[normalStr length]>0) {
        [self setTitle:normalStr forState:UIControlStateNormal];
        [self setTitle:normalStr forState:UIControlStateHighlighted];
    }
    if (selectStr&&[selectStr length]>0) {
        [self setTitle:selectStr forState:UIControlStateSelected];
        [self setTitle:selectStr forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}

-(void)setSafeColorWithNormalColor:(UIColor *)normalColor select:(UIColor *)selectColor{
    
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateHighlighted];
    [self setTitleColor:selectColor forState:UIControlStateSelected];
    [self setTitleColor:selectColor forState:UIControlStateSelected | UIControlStateHighlighted];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////

static char topEdgeKey;
static char leftEdgeKey;
static char bottomEdgeKey;
static char rightEdgeKey;

-(void)setEnlargedEdge:(CGFloat)enlargedEdge{
    
    [self setEnlargedEdgeWithTop:enlargedEdge left:enlargedEdge bottom:enlargedEdge right:enlargedEdge];
}

-(CGFloat)enlargedEdge{
    
    return [(NSNumber *)objc_getAssociatedObject(self, &topEdgeKey) floatValue];
}

-(void)setEnlargedEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self,&topEdgeKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self,&leftEdgeKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self,&bottomEdgeKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self,&rightEdgeKey);
    if (topEdge&&leftEdge&&bottomEdge&&rightEdge) {
        CGRect enlargedRect = CGRectMake(self.bounds.origin.x -leftEdge.floatValue, self.bounds.origin.y-topEdge.floatValue, self.bounds.size.width+leftEdge.floatValue + rightEdge.floatValue, self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
        return enlargedRect;
    } else {
        return self.bounds;
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.alpha <= 0.01 || !self.userInteractionEnabled || self.hidden) {
        
        return nil;
    }
    
    CGRect enlargedRect = [self enlargedRect];
    return CGRectContainsPoint(enlargedRect, point) ? self : nil;
}

@end
