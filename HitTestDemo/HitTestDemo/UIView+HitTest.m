//
//  UIView+HitTest.m
//  HitTestDemo
//
//  Created by Start on 2018/11/26.
//  Copyright © 2018年 Start. All rights reserved.
//

#import "UIView+HitTest.h"
#import <objc/message.h>
@implementation UIView (HitTest)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL oriSel = @selector(hitTest:withEvent:);
        SEL swiSel = @selector(log_hitTest:withEvent:);
        //方法的Method
        Method oriMethod = class_getInstanceMethod(class, oriSel);
        Method swiMethod = class_getInstanceMethod(class, swiSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL didAddMethod = class_addMethod(class, oriSel, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        if (didAddMethod) {
            NSLog(@"添加成功");
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swiSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
            [self getMethodList];
        }else
        {
             //否则，交换两个方法的实现
            method_exchangeImplementations(swiMethod, oriMethod);
            [self getMethodList];
        }
      
    });
}
-(UIView *)log_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //打印点击的类
    NSLog(@"%@  -----  %s",[self class],__PRETTY_FUNCTION__);
    return [self log_hitTest:point withEvent:event];
}

+(void)getMethodList
{
    u_int count;
    //class_copyMethodList  获取所有方法的数组
    Method *methodLists = class_copyMethodList([self class], &count);
    for(int i=0;i<count;i++)
    {
        Method tmpMethod = methodLists[i];
        //获取IMP函数指针
        IMP impMethod = method_getImplementation(tmpMethod);
        //获取的到SEL
        SEL nameSel = method_getName(tmpMethod);
        const char *nameFromSel = sel_getName(nameSel);
        //参数个数
        int arguments = method_getNumberOfArguments(tmpMethod);
        const char *encoding = method_getTypeEncoding(tmpMethod);
        NSLog(@"方法名：%@\n,参数个数：%d\n,编码方式：%@\n",[NSString stringWithUTF8String:nameFromSel],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
}
@end
