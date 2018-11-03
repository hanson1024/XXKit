//
//  LSVersionUpdateView.h
//  contact
//
//  Created by luo on 2018/10/31.
//  Copyright © 2018年 gdtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSVersionUpdateView : UIView

/** <#name#> */
@property (nonatomic, assign) CGFloat lineSpacing;
/** <#注释#> */
@property (nonatomic, copy) void(^didClickUpdateButtonBlock) (NSInteger idx);

+ (instancetype)showUpdateWithTitles:(NSArray *)titles versionStr:(NSString *)versionStr newVersionStr:(NSString *)newVersionStr force:(BOOL )isForce;

- (void)showInView:(UIView *)containerView;

@end
