//
//  DZMDynamicAnimatorView.h
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#define BGColor [UIColor colorWithRed:32/255.0f green:47/255.0f blue:63/255.0f alpha:1.0]
#define DZMDynamicAnimatorView_H 300
#define DZMSpace_H 0.5
#define DZMMin_Y 130

#import <UIKit/UIKit.h>

@interface DZMDynamicAnimatorView : UIView

@property (nonatomic, assign, readonly) CGRect selfFrame;

/**
 幅度点
 */
@property (nonatomic, strong) UIView *controlPoint;

/**
 正在加载
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 弹射动画
 */
- (void)push;

/**
 开始加载
 */
- (void)startLoading;

/**
 结束加载
 */
- (void)endLoading;
@end
