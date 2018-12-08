//
//  LSVersionUpdateView.m
//  contact
//
//  Created by luo on 2018/10/31.
//  Copyright © 2018年 gdtech. All rights reserved.
//

#import "LSVersionUpdateView.h"

@interface LSUnselectableTextView : UITextView

- (BOOL)canBecomeFirstResponder;

@end

@implementation LSUnselectableTextView

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end

static const CGFloat kLSReleaseNotesViewContainerViewCornerRadius = 10.0f;
static const CGFloat kLSReleaseNotesViewContainerViewWidth = 265.0f;
static const CGFloat kLSReleaseNotesViewInnerContainerSidePadding = 15.0f;
static const CGFloat kLSReleaseNotesViewButtonBoxHeight = 48.0f;
static const CGFloat kLSReleaseNotesViewAnimationSpringScaleFactor = 0.05f;
static const NSTimeInterval kLSReleaseNotesViewTransitionDuration = 0.2f;

@interface LSVersionUpdateView ()
//UI
/** <#注释#> */
@property (nonatomic, strong) UIView *popupView;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *backImagView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *versionLabel;
/** <#注释#> */
@property (nonatomic, strong) LSUnselectableTextView *textView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *removeButton;
/** <#注释#> */
@property (nonatomic, strong) UIButton *cancelButton;
/** <#注释#> */
@property (nonatomic, strong) UIButton *updateButton;

//DATA
/** <#注释#> */
@property (nonatomic, strong) NSArray *titles;
/** 是否为强制更新 */
@property (nonatomic, assign) BOOL isForce;

@end

@implementation LSVersionUpdateView

#pragma mark - life cycle

+ (instancetype)showUpdateWithTitles:(NSArray *)titles versionStr:(NSString *)versionStr newVersionStr:(NSString *)newVersionStr force:(BOOL )isForce{
    
    LSVersionUpdateView *updateVersionView = [[LSVersionUpdateView alloc] initWithTitles:titles versionStr:versionStr newVersionStr:newVersionStr force:isForce];
    
    return updateVersionView;
}

- (instancetype)initWithTitles:(NSArray *)titles versionStr:(NSString *)versionStr newVersionStr:(NSString *)newVersionStr force:(BOOL )isForce{
    
    if (self = [super init]) {
        
        self.lineSpacing = 12.5f;
        self.isForce = isForce;
        
        NSString *title = @"";
        
        for (NSString *str in titles) {
            title = [title stringByAppendingString:[NSString stringWithFormat:@"- %@ \n",str]];
        }
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        _popupView = [[UIView alloc] initWithFrame:CGRectZero];
        [_popupView setBackgroundColor:[UIColor whiteColor]];
        [_popupView setClipsToBounds:NO];
        [_popupView.layer setCornerRadius:kLSReleaseNotesViewContainerViewCornerRadius];
        [_popupView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self addSubview:_popupView];
        
        _backImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LS火箭biubiu"]];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(18);
        _titleLabel.textColor = [UIColor orangeColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.text = STRING_FORMAT(@"发现新版本V%@",newVersionStr);
        _titleLabel.text = @"发现新版本";
        
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = FONT(12);
        _versionLabel.textColor = [UIColor orangeColor];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.text = versionStr;
        
        _textView = [[LSUnselectableTextView alloc] initWithFrame:CGRectZero];
        [_textView setBackgroundColor:[UIColor whiteColor]];
        _textView.font = FONT(12);
        _textView.textColor = [UIColor orangeColor];
        [_textView setEditable:NO];
        
        if ([title length]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
            [attributedString addAttribute:NSFontAttributeName value:_textView.font range:NSMakeRange(0, [title length])];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:self.lineSpacing];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
            _textView.attributedText = attributedString;
        }
        
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeButton.tag = 2;
        [_removeButton setTitle:@"  跳过本次版本更新" forState:UIControlStateNormal];
        [_removeButton setImage:[UIImage imageNamed:@"LS_state_default"] forState:UIControlStateNormal];
        [_removeButton setImage:[UIImage imageNamed:@"LS_state_selected"] forState:UIControlStateSelected];
        [_removeButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_removeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        _removeButton.titleLabel.font = FONT(14);
        _removeButton.hidden = isForce;
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        _cancelButton.tag = 0;
        [_cancelButton setTitle:@"暂不更新" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT(18);
        _cancelButton.hidden = isForce;
        
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.tag = 1;
        [_updateButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [_updateButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_updateButton setTitle:@"立即体验" forState:UIControlStateNormal];
        _updateButton.titleLabel.font = FONT(18);
        
        [_popupView addSubview:_backImagView];
        [_popupView addSubview:_titleLabel];
        [_popupView addSubview:_versionLabel];
        [_popupView addSubview:_textView];
        [_popupView addSubview:_removeButton];
        [_popupView addSubview:_cancelButton];
        [_popupView addSubview:_updateButton];
        
    }
    
    return self;
}

#pragma mark - public methods

- (void)showInView:(UIView *)containerView
{
    [self _prepareToShowInView:containerView];
    
    [UIView animateWithDuration:kLSReleaseNotesViewTransitionDuration animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5f]];
        [self.popupView setAlpha:1.0f];
        [self.popupView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0f + kLSReleaseNotesViewAnimationSpringScaleFactor, 1.0f + kLSReleaseNotesViewAnimationSpringScaleFactor)];
    } completion:^(BOOL finished){
        if (finished)
        {
            [UIView animateWithDuration:kLSReleaseNotesViewTransitionDuration/2.0f animations:^{
                [self.popupView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0f - kLSReleaseNotesViewAnimationSpringScaleFactor, 1.0f - kLSReleaseNotesViewAnimationSpringScaleFactor)];
            } completion:^(BOOL finished){
                if (finished)
                {
                    [UIView animateWithDuration:kLSReleaseNotesViewTransitionDuration/2.0f animations:^{
                        [self.popupView setTransform:CGAffineTransformIdentity];
                    }];
                }
            }];
        }
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:kLSReleaseNotesViewTransitionDuration/2.0f animations:^{
        [self.popupView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0f + kLSReleaseNotesViewAnimationSpringScaleFactor, 1.0f + kLSReleaseNotesViewAnimationSpringScaleFactor)];
    } completion:^(BOOL finished){
        if (finished)
        {
            [UIView animateWithDuration:kLSReleaseNotesViewTransitionDuration animations:^{
                [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
                [self.popupView setAlpha:0.0f];
                [self.popupView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.0f, 0.0f)];
            } completion:^(BOOL finished){
                if (finished)
                {
                    [self removeFromSuperview];
                }
            }];
        }
    }];
}

#pragma - mark
#pragma mark - private methods 添加 pri_ 前缀

- (void)_prepareToShowInView:(UIView *)containerView
{
    
    [self _updateSubviewsLayoutInContainerView:containerView];
    [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [self.popupView setAlpha:0.0f];
    [self.popupView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.0f, 0.0f)];
    [containerView addSubview:self];
}

- (void)_updateSubviewsLayoutInContainerView:(UIView *)containerView
{
    
    CGRect containerBounds = [containerView bounds];
    [self setFrame:containerBounds];
    
    CGFloat x = 0;
    CGFloat y = - 80;
    CGFloat width = kLSReleaseNotesViewContainerViewWidth;
    CGFloat height = kLSReleaseNotesViewContainerViewWidth *self.backImagView.image.size.height / self.backImagView.image.size.width;
    [self _setupFrameForView:self.backImagView frame:CGRectMake(x, y, width, height)];
    
    x = 0;
    y = CGRectGetMaxY(self.backImagView.frame) + 10;
    width = kLSReleaseNotesViewContainerViewWidth;
    height = 20;
    [self _setupFrameForView:self.titleLabel frame:CGRectMake(x, y, width, height)];
    
    x = 0;
    y = CGRectGetMaxY(self.titleLabel.frame) + 10;
    width = kLSReleaseNotesViewContainerViewWidth;
    height = 10;
    [self _setupFrameForView:self.versionLabel frame:CGRectMake(x, y, width, height)];
    
    x = kLSReleaseNotesViewInnerContainerSidePadding;
    y = CGRectGetMaxY(self.versionLabel.frame) + 10;
    width = kLSReleaseNotesViewContainerViewWidth - 2*kLSReleaseNotesViewInnerContainerSidePadding;
    height = [self _expectedReleaseNotesTextHeightWithWidth:width];
    [self _setupFrameForView:self.textView frame:CGRectMake(x, y, width, height)];
    
    x = 0;
    y = CGRectGetMaxY(self.textView.frame);
    [self _setupFrameForView:self.removeButton frame:CGRectMake(x, y, kLSReleaseNotesViewContainerViewWidth, 20)];
    
    x = (SCREEN_WIDTH - kLSReleaseNotesViewContainerViewWidth) *.5;
    width = kLSReleaseNotesViewContainerViewWidth;
    height = CGRectGetMaxY(self.textView.frame) + (self.isForce ? 50 : 90);
    y = (SCREEN_HEIGHT - height) *.5 + 30;
    [self _setupFrameForView:self.popupView frame:CGRectMake(x, y, width, height)];
    
    x = 0;
    if (!self.isForce) {
        y = CGRectGetMaxY(self.removeButton.frame) + 20;
    } else {
        y = CGRectGetMaxY(self.textView.frame);
    }
    width = kLSReleaseNotesViewContainerViewWidth *.5;
    height = kLSReleaseNotesViewButtonBoxHeight;
    [self _setupFrameForView:self.cancelButton frame:CGRectMake(x, y, width, height)];
    
    if (self.isForce) {
        x = 0;
        width = kLSReleaseNotesViewContainerViewWidth;
    } else {
        x = kLSReleaseNotesViewContainerViewWidth *.5;
    }
    [self _setupFrameForView:self.updateButton frame:CGRectMake(x, y, width, height)];
    
    [self setBorderWithTop:YES left:NO bottom:NO right:YES borderColor:[UIColor darkGrayColor] borderWidth:.5 forView:self.cancelButton];
    [self setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:[UIColor darkGrayColor] borderWidth:.5 forView:self.updateButton];
}

- (void)_setupFrameForView:(UIView *)view frame:(CGRect )frame {
    
    view.frame = frame;
}

- (CGFloat)_expectedReleaseNotesTextHeightWithWidth:(CGFloat)width;
{
    
    if ([_textView.attributedText length]) {
        NSDictionary *attributes = [_textView.attributedText attributesAtIndex:0 effectiveRange:nil];
        NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
        
        CGRect messageRect = [_textView.attributedText.string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                                           options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:newAttributes
                                                                           context:nil];
        
        CGFloat maxHeight = SCREEN_HEIGHT *.5;
        
        return messageRect.size.height > maxHeight ? maxHeight : messageRect.size.height;
    }else {
        return CGFLOAT_MIN;
    }
}

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width forView:(UIView *)view{
    
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(15, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

#pragma - mark
#pragma mark - delegate
#pragma mark - tableViewDelegate
#pragma mark - event response

-(void)didClickButton:(UIButton *)button {
    
    !self.didClickUpdateButtonBlock?:self.didClickUpdateButtonBlock(button.tag);
    
    if (button.tag == 2) {
        
        button.selected = !button.isSelected;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        
    }else {
        [self dismiss];
    }
    
}

#pragma - mark
#pragma mark - lazy loading

@end
