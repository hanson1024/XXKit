//
//  XXBaseNavgationController.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXBaseNavgationController.h"

@interface XXBaseNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation XXBaseNavgationController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        // 左上角
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:[UIImage imageNamed:@"yxx_back"] forState:UIControlStateNormal];
//        backButton.frame = CGRectMake(0, 0, 44, 44);
//        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
        
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES;
//        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - public methods
#pragma - mark
#pragma mark - private methods 添加 pri_ 前缀



#pragma - mark
#pragma mark - delegate
#pragma mark - tableViewDelegate
#pragma mark - event response

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1 就有效
    return self.childViewControllers.count > 1;
}

-(void)back {
    
    if (self.viewControllers.lastObject && [self.viewControllers.lastObject respondsToSelector:@selector(popBackController)]) {
        [self.viewControllers.lastObject performSelector:@selector(popBackController)];
        return;
    }
    
    [self popViewControllerAnimated:YES];
}

#pragma - mark
#pragma mark - lazy loading



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
