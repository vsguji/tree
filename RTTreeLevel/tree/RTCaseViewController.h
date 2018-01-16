//
//  RTAuthorViewController.h
//  darongtong
//
//  Created by zy on 2017/8/30.
//  Copyright © 2017年 darongtong. All rights reserved.
//
// 推荐给谁看 | 公开给谁看
#import "RootViewController.h"
/*
 * @Detail view_Type
 *  0|所有人 1|坛 2|好友坛 3|八方坛 4|公关坛 5|公坛 6|私坛 7|约谈 8|红坛 9|遣颂坛 21|个性 22|家乡 23|圈子 24|关注 25|收藏 26|看好 27|观察  28|赞 29|8类资本组合 41|摆在 店铺/ 家里私有
 *  默认0 (选填)
 */
#import <UIKit/UIKit.h>

@interface RTCaseItem : NSObject<NSCopying,NSCoding>
@property (nonatomic,assign) BOOL selectFlg;  // 已经选中
@property (nonatomic,assign) BOOL willSelectFlag; // 即将选中
@property (nonatomic,assign) BOOL levelTop;  // 根
@property (nonatomic,assign) BOOL levelTopOpen; // 根&&选中状态;
@end

@interface RTCaseViewController :RootViewController
@property (nonatomic,copy) void(^block)(NSString *viewName,int view_type);

@end
