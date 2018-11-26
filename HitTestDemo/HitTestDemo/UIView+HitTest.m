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
            
            
            // 添加方法
//            BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
//            
//            // 获取实例方法
//            Method class_getInstanceMethod ( Class cls, SEL name );
//            
//            // 获取类方法
//            Method class_getClassMethod ( Class cls, SEL name );
//            
//            // 获取所有方法的数组
//            Method * class_copyMethodList ( Class cls, unsigned int *outCount );
//            
//            // 替代方法的实现
//            IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
//            
//            // 返回方法的具体实现
//            IMP class_getMethodImplementation ( Class cls, SEL name );
//            
//            IMP class_getMethodImplementation_stret ( Class cls, SEL name );
//            
//            // 类实例是否响应指定的selector
//            BOOL class_respondsToSelector ( Class cls, SEL sel );
//            
//            作者：齐滇大圣
//            链接：https://www.jianshu.com/p/73e454178e77
//            來源：简书
//            简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
            
//            如果方法添加成功，则说明原类并不存在将要被替换的 originalMethod，此时我们再对名为 swizzledSelector方法进行整体结构替换，这样一来我们变向实现了方法交换，你在调用原类 originalSelector 时的实现为 swizzledMethod结构中的具体内容，而原本用来交换的方法 swizzledSelector 的实现也变成了 originalMethod 的具体实现。如果方法添加失败，则说明原类中已经存在了要被替换的 originalSelector，可以安全的进行 method_exchangeImplementations 交换
//            链接：https://www.jianshu.com/p/c4b59bd2cd83
            
            
            
            
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
