//
//  XXHomeViewController.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXHomeViewController.h"
#import "XXHomeTableViewCell.h"

@interface XXHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

//UI
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;

//DATA
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray <NSArray *>*dataSource;

@end

@implementation XXHomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"XXKit";
    
    [self setupDataSource];
    [self addTableViewWithTableViewStyle:UITableViewStyleGrouped];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
#pragma - mark
#pragma mark - private methods 添加 pri_ 前缀

-(void)addTableViewWithTableViewStyle:(UITableViewStyle )style {
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(self.nav_status_height, 0, SAFE_BOTTOM, 0);
    [_tableView registerClass:[XXHomeTableViewCell class] forCellReuseIdentifier:@"XXHomeTableViewCell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupDataSource {
    
    _dataSource = [NSMutableArray array];
    
    NSMutableArray *models = [NSMutableArray array];
    XXHomeModel *model = [[XXHomeModel alloc] init];
    model.cellName = @"图片相关";
    model.VCName = @"一行代码获取图片";
    model.VCStr = @"XXImageViewController";
    [models addObject:model];
    
    [_dataSource addObject:models];
}

#pragma - mark
#pragma mark - delegate
#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_dataSource count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_dataSource objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXHomeTableViewCell" forIndexPath:indexPath];
    cell.model = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXHomeModel *model = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [self gotoViewControllerWithModel:model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - event response

- (void)gotoViewControllerWithModel:(XXHomeModel *)model {
    
    UIViewController *VC = [NSClassFromString(model.VCStr) new];
    VC.title = model.VCName;
    [self.navigationController pushViewController:VC animated:YES];
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
