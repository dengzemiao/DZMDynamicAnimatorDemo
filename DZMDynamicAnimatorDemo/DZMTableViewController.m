//
//  DZMTableViewController.m
//  DZMDynamicAnimatorDemo
//
//  Created by 邓泽淼 on 2017/2/7.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "DZMTableViewController.h"
#import "DZMDynamicAnimatorView.h"
#import "DZMTableViewCell.h"

@interface DZMTableViewController ()

@property (nonatomic, strong) DZMDynamicAnimatorView *dynamicAnimatorView;

@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation DZMTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = BGColor;
    
    self.tableView.backgroundColor = BGColor;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DZMTableViewCell *cell = [DZMTableViewCell cellWithTableView:tableView];
    
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%ld",(long)indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - Table view delegate

// 下拉过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -DZMSpace_H) {
       
        [self remove];
        
        return;
    }
    
    if ((-scrollView.contentOffset.y - DZMSpace_H) > 0 && self.dynamicAnimatorView == nil) { // 下拉
   
        [self creat];
        
    }else if ((-scrollView.contentOffset.y - DZMSpace_H) < 0){ // 结束下拉
      
        [self remove];
    }
}

// 准备松手的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset = -scrollView.contentOffset.y - DZMSpace_H;
    
    CGFloat min_Y = DZMMin_Y;
    
    if (offset >= min_Y) {
        
        self.dynamicAnimatorView.isLoading = YES;
    }
}

// 松手的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    __weak DZMTableViewController *weakSelf = self;
    
    CGFloat offset = -scrollView.contentOffset.y - DZMSpace_H;
    
    CGFloat min_Y = DZMMin_Y;
    
    if (offset >= min_Y) {
        
        [UIView animateWithDuration:0.25 delay:0.1f usingSpringWithDamping:0.8f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.dynamicAnimatorView.controlPoint.center = CGPointMake(self.dynamicAnimatorView.frame.size.width / 2, DZMDynamicAnimatorView_H);
            
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(min_Y + DZMSpace_H, 0, 0, 0);
            
        } completion:^(BOOL finished) {
            
            [weakSelf performSelector:@selector(complete) withObject:nil afterDelay:2.0f];
            
        }];
    }
}

// 完成
- (void)complete
{
    __weak DZMTableViewController *weakSelf = self;
    
    [self.dynamicAnimatorView endLoading];
    
    [UIView animateWithDuration:0.25 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } completion:^(BOOL finished) {
        
        weakSelf.dynamicAnimatorView.isLoading = NO;
        
        [weakSelf remove];
    }];
}

// 创建
- (void)creat
{
    // DZMDynamicAnimatorView
    self.dynamicAnimatorView = [[DZMDynamicAnimatorView alloc] initWithFrame:CGRectMake(0, -DZMDynamicAnimatorView_H, [UIScreen mainScreen].bounds.size.width, DZMDynamicAnimatorView_H)];
    [self.view addSubview:self.dynamicAnimatorView];
    
    
    // CADisplayLink
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 移除
- (void)remove
{
    if (self.dynamicAnimatorView) {
        
        [self.dynamicAnimatorView removeFromSuperview];
        
        self.dynamicAnimatorView = nil;
    }
    
    if (self.displayLink) {
    
        [self.displayLink invalidate];
        
        self.displayLink = nil;
    }
}

#pragma mark - Action

- (void)displayLinkAction:(CADisplayLink *)displayLink
{
    if (self.dynamicAnimatorView.isLoading) {
        
    }else{
        
        self.dynamicAnimatorView.controlPoint.center =  CGPointMake(self.dynamicAnimatorView.selfFrame.size.width / 2, self.dynamicAnimatorView.selfFrame.size.height + (-self.tableView.contentOffset.y - DZMSpace_H));
    }
    
    [self.dynamicAnimatorView setNeedsDisplay];
}

@end
