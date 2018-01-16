//
//  RTAuthCell.m
//  darongtong
//
//  Created by zy on 2017/8/30.
//  Copyright © 2017年 darongtong. All rights reserved.
//

#import "RTCaseCell.h"

@implementation RTCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    UIImageView *icon = self.imageView;
    icon.frame = CGRectMake(self.origionX, icon.frame.origin.y, CGRectGetWidth(icon.frame), CGRectGetHeight(icon.frame));
    icon.contentMode = UIViewContentModeScaleAspectFit;
}
@end
