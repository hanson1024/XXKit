//
//  XXImageViewController.m
//  XXKit
//
//  Created by luo on 2018/10/24.
//  Copyright © 2018年 hanson. All rights reserved.
//

#import "XXImageViewController.h"
#import "XXImageTool.h"
#import "UIButton+Common.h"

@interface XXImageViewController ()

/** <#注释#> */
@property (nonatomic, strong) UIImageView *bgImageView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *photoButton;


@end

@implementation XXImageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WEAK_SELF(weakSelf);
    _photoButton = [UIButton buttonWithStyle:CustomButtonTypeBigCornerAndGradient andTitle:@"获取图片" andFrame:CGRectMake(15, self.view.height - 44 - SAFE_BOTTOM - 30, SCREEN_WIDTH - 30, 44) actionBlock:^{
        [weakSelf openPhotos];
    }];
    
    [self.view addSubview:_photoButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - public methods
#pragma - mark
#pragma mark - private methods 添加 pri_ 前缀
#pragma - mark
#pragma mark - delegate
#pragma mark - tableViewDelegate
#pragma mark - event response

- (void)openPhotos {
    WEAK_SELF(weakSelf);
    [[XXImageTool shareManager] openMobileImagesWithType:YXXImageToolSourceTypeCamera maxImagesCount:1 finishBlock:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.bgImageView.image = photos.firstObject;
    }];
}

#pragma - mark
#pragma mark - lazy loading

-(UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
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
