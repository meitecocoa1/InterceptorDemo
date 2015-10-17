//
//  CTViewControllerIntercepter.m
//  Interceptor
//
//  Created by co-meite on 15/10/17.
//  Copyright © 2015年 co-meite. All rights reserved.
//

#import "CTViewControllerIntercepter.h"
#import <Aspects/Aspects.h>
#import <UIKit/UIKit.h>

@implementation CTViewControllerIntercepter


+(void)load
{
    [super load];
    [CTViewControllerIntercepter sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTViewControllerIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[CTViewControllerIntercepter alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//                方法拦截
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo) {
            
            [self loadView:[aspectInfo instance]];
        }error:nil];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, BOOL animated){
            
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        }error:nil];
    }
    return self;
}


#pragma mark --fake method

- (void)loadView:(UIViewController *)viewController
{
    NSLog(@"[%@ loadView]", [viewController class]);
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController
{
    NSLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
}
@end
