//
//  DZMBall.m
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMBall.h"

@implementation DZMBall

- (UIDynamicItemCollisionBoundsType)collisionBoundsType
{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
