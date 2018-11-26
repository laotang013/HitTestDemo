//
//  AView.m
//  HitTestDemo
//
//  Created by Start on 2018/11/26.
//  Copyright © 2018年 Start. All rights reserved.
//

#import "AView.h"
#import "UIView+HitTest.h"
#import "AView+AView.h"
@implementation AView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}


/*
  视图查找流程
    1.调用hitTest方法进行最优响应查询
     hidden = YES
     userInteractionEnable = NO
     alpha<0.01
      以上三种情况会使该方法返回nil.即当前视图下无最优视图。
    2.hitTest方法内部会调用pointInside方法对点击进行是否在当前视图bounds内进行判断，如果超出bounds，hitTest则返回nil,未超出范围则进行步骤3
   3.对当前视图下的subView逆序采取上述 1 2步骤以查询最优响应视图。如果hitTest返回了对应视图则说明在当前视图层级下有最优响应视图。可能为self或者其subView
 
 事件分发与传递:自上而下
 事件响应:自下而上
 
 UIApplication开始自上而下的进行事件分发
 UIView内部开始反向遍历查找最优视图
 */

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.alpha < 0.01 || !self.userInteractionEnabled || self.hidden) {
        
        return nil;
    }
    
    if (![self pointInside:point withEvent:event]) {
        
        return nil;
    }
    
    __block UIView *hitView = nil;
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        
        hitView = [subview hitTest:point withEvent:event];
        if (hitView) {
            
            *stop = YES;
        }
    }];
    
    return hitView ? : self;
}
@end
