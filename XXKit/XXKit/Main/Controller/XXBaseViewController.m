//
//  XXBaseViewController.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXBaseViewController.h"

@interface XXBaseViewController ()

@end

@implementation XXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.nav_status_height = STATUS_BAR_HEIGHT + CONST_NAV_BAR_HEIGHT;
    // Do any additional setup after loading the view.
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
