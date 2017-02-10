//
//  DZMDynamicAnimatorView.m
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#define DZMBall_WH 30
#define DZMControlPoint_WH 2

#import "DZMDynamicAnimatorView.h"
#import "DZMBall.h"
#import <UIKit/UIKit.h>

@interface DZMDynamicAnimatorView()

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) DZMBall *ball;

@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) BOOL isStartLoading;

@end

@implementation DZMDynamicAnimatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    _selfFrame = frame;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + [UIScreen mainScreen].bounds.size.height)];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // CAShapeLayer
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = BGColor.CGColor;
        [self.layer addSublayer:self.shapeLayer];
        
        // 幅度点
        UIView *controlPoint = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - DZMControlPoint_WH/2, frame.size.height - DZMControlPoint_WH/2, DZMControlPoint_WH, DZMControlPoint_WH)];
        [self addSubview:controlPoint];
        controlPoint.backgroundColor = [UIColor clearColor];
        self.controlPoint = controlPoint;
        
        // Ball
        self.ball = [[DZMBall alloc] init];
//        self.ball.image = [UIImage imageNamed:@"Ball_1"];
        self.ball.image = [UIImage imageNamed:@"Ball_2"];
        self.ball.frame = CGRectMake(20, 0, DZMBall_WH, DZMBall_WH);
        [self addSubview:self.ball];
        
        // DynamicAnimator
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        // GravityBehavior
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
        gravityBehavior.magnitude = 2;
        [self.animator addBehavior:gravityBehavior];
        
        // CollisionBehavior
        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ball]];
        [self.animator addBehavior:self.collisionBehavior];
        
        // Ball Property
        UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
        ballBehavior.elasticity = 0.4;
        ballBehavior.allowsRotation = YES;
        ballBehavior.friction = 1;
        ballBehavior.resistance = 0.5;
        [self.animator addBehavior:ballBehavior];
    }
    return self;
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    
    self.isStartLoading = isLoading;
}

- (UIBezierPath *)GetPath
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.selfFrame.size.width, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.selfFrame.size.width, self.selfFrame.size.height)];
    [bezierPath addQuadCurveToPoint:CGPointMake(0, self.selfFrame.size.height) controlPoint:self.controlPoint.center];
    [bezierPath closePath];
    
    return bezierPath;
}

- (void)push
{
    // 弹射动画
    if (self.isStartLoading) {
        
        self.isStartLoading = NO;
        
        self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.ball snapToPoint:CGPointMake(self.selfFrame.size.width / 2, self.selfFrame.size.height - (DZMMin_Y + DZMSpace_H)/2)];

        self.snapBehavior.damping = 0.5;
        
        [self.animator addBehavior:self.snapBehavior];

        [self startLoading];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.isLoading) {
      
        [self push];
        
    }else{
        
        [self.collisionBehavior removeBoundaryWithIdentifier:@"COLLISION_BOUNDARY_BEZIER"];
    }
    
    self.bezierPath = [self GetPath];
    
    self.shapeLayer.path = self.bezierPath.CGPath;
    
    if (!self.isLoading) {
        
        [self dragBallBackIfNeeded];
        
        [self.collisionBehavior addBoundaryWithIdentifier:@"COLLISION_BOUNDARY_BEZIER" forPath:self.bezierPath];
        
        [self.animator addBehavior:self.collisionBehavior];

    }
}

- (void)startLoading
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.9f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.ball.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endLoading
{
    [self.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)dragBallBackIfNeeded
{
    if (![self.bezierPath containsPoint:self.ball.center]) {
        
        self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y - DZMBall_WH);
        
        [self.animator updateItemUsingCurrentState:self.ball];
    }
}

@end
