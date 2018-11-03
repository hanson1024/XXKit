//
//  XXUpdateVersionViewController.m
//  XXKit
//
//  Created by luo on 2018/10/31.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXUpdateVersionViewController.h"
#import "LSVersionManager.h"

@interface XXUpdateVersionViewController ()

@end

@implementation XXUpdateVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [LSVersionManager checkAppVersionDataWithForce:YES];
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
