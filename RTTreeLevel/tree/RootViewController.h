//
//  RootViewController.h
//  darongtong
//
//  Created by darongtong on 15/9/17.
//  Copyright © 2015年 rongtong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(NSString *tokenString);
typedef void(^LoginBackBlock)(BOOL isLoginSuccess);

@interface RootViewController : UIViewController

@property(nonatomic,retain) UIBarButtonItem *rightItem;

@property (nonatomic,assign)BOOL isPresent;

@property (nonatomic,assign)BOOL haveToken;

@property (nonatomic, copy) LoginBlock loginBlock;


- (void)customBackButtonAction:(UIButton*)button;

- (void)doClickBackAction;
- (void)setNavigationBarBackgroundImage:(NSString *)imageString;
- (void)setRightTitleNavigationBar:(NSString *)rightTitle;
- (void)setRightImageNavigationBar:(NSString *)rightImage;
- (void)rightBarItemClicked:(id)sender;
- (void)leftBarItemClicked:(id)sender;
- (void)setNavigationBarStyle;
- (void)hiddenLeftNavigationbar;
- (void)hiddenBackNavigationbar;
- (void)setLeftImageNavigationBar:(NSString *)leftImage;
- (void)setBackImageNavigationBar:(NSString *)backImage;
- (void)setCustomRightNavigationBar:(UIButton *)customButton;
- (void)setLeftTitleNavigationBar:(NSString *)leftTitle;
- (void)addYueTanRequestAFN:(NSObject *)mModel type:(NSString*)type;



@end
