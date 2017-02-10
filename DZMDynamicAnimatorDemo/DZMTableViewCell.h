//
//  DZMTableViewCell.h
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZMTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView *img;

@end
