//
//  DZMTableViewCell.m
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMTableViewCell.h"

@implementation DZMTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DZMTableViewCell";
    
    DZMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[DZMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.img = [[UIImageView alloc] init];
        
        self.img.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.img];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.img.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
