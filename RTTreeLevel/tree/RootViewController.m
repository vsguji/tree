//
//  RootViewController.m
//  darongtong
//
//  Created by darongtong on 15/9/17.
//  Copyright © 2015年 rongtong. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIGestureRecognizerDelegate>

@end

@implementation RootViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout =UIRectEdgeNone;//modify
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucced) name:@"userLoginSucceed" object:nil];    
    [self setNavigationBarStyle];
    [self setLeftImageNavigationBar:@"navigationBack"];
    
}


/**
 去掉导航栏左侧按钮
 */
- (void)hiddenLeftNavigationbar{
    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hi =YES;
}

/**
 去掉导航栏返回按钮
 */

- (void)hiddenBackNavigationbar{
//    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton =YES;
}



/**
 设置导航栏样式
 */
- (void)setNavigationBarStyle{
    
    UIFont *font = [UIFont systemFontOfSize:17.f];
    
    NSDictionary *textAttributes = @{ NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                      };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    
    
}


/**
 设置返回按钮图片

 @param backImage <#backImage description#>
 */
- (void)setBackImageNavigationBar:(NSString *)backImage{
    
    UIImage *backButtonIcon = [[UIImage imageNamed:backImage]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonIcon
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backBarItemClicked)];
    self.navigationItem.backBarButtonItem = backButton;
    
}



/**
 设置导航栏左侧按钮图片


 @param leftImage <#leftImage description#>
 */
- (void)setLeftImageNavigationBar:(NSString *)leftImage{
    
    UIImage *leftButtonIcon = [[UIImage imageNamed:leftImage]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftButtonIcon
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}


/**
 设置导航栏左侧文字按钮

 @param leftTitle <#leftTitle description#>
 */
- (void)setLeftTitleNavigationBar:(NSString *)leftTitle{
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}



/**
 导航栏左侧按钮响应方法
 */
- (void)leftBarItemClicked:(id)sender{
    
    if (_isPresent == YES) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


/**
 返回按钮响应方法
 */
- (void)backBarItemClicked{
    
    if (_isPresent == YES) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/**
 设置导航栏背景图片
 
 @param imageString <#imageString description#>
 */
- (void)setNavigationBarBackgroundImage:(NSString *)imageString{
    
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage imageNamed:imageString] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imageString] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

}


/**
 设置导航栏右侧文字按钮
 
 @param rightTitle <#rightTitle description#>
 */
- (void)setRightTitleNavigationBar:(NSString *)rightTitle{
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}


/**
 设置导航栏右侧图片按钮
 
 @param rightImage <#rightImage description#>
 */
- (void)setRightImageNavigationBar:(NSString *)rightImage{
    
    UIImage *rightButtonIcon = [[UIImage imageNamed:rightImage]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightButtonIcon
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(rightBarItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}


/**
 设置自定义导航栏按钮

 @param customButton <#customButton description#>
 */
- (void)setCustomRightNavigationBar:(UIButton *)customButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    self.navigationController
    self.navigationItem.rightBarButtonItems = @[rightItem];

}


/**
 导航栏右侧按钮点击相应方法
 */
- (void)rightBarItemClicked:(id)sender{
    
    
}


- (void)doClickBackAction
{
    if (_isPresent == YES) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)customBackButtonAction:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 点击屏幕关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma -mark 点击屏幕取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
}

- (void)loginSucced{
    if (self.loginBlock) {
    }
}

//显示加载
- (void)showHUD:(NSString *)title {
    [self hideHUD];
}

//隐藏加载
- (void)hideHUD {
}


@end
