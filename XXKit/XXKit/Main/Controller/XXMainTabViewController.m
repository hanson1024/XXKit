//
//  XXMainTabViewController.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXMainTabViewController.h"

#import "XXBaseNavgationController.h"
#import "XXHomeViewController.h"

@interface XXMainTabViewController ()

@end

@implementation XXMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentViewController:) name:nPresentViewController object:nil];
    
    [self setupSubViewControllers];
    // Do any additional setup after loading the view.
}

- (void)setupSubViewControllers {
    
    XXHomeViewController *VC = [[XXHomeViewController alloc] init];
    XXBaseNavgationController *navVC = [[XXBaseNavgationController alloc] initWithRootViewController:VC];
    
    self.viewControllers = @[navVC];
}

- (void)presentViewController:(NSNotification *)notification {
    
    NSDictionary *notiObj = notification.object;
    
    if ([notiObj objectForKey:PresentViewControllerParamsKey]) {
        
        UIViewController *VC = [notiObj objectForKey:PresentViewControllerParamsKey];
        
        [self presentViewController:VC animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
