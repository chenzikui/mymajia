//
//  UINavigationItem+Addition.m
//  Dobby
//
//  Created by efeng on 14-6-6.
//  Copyright (c) 2014年 weiboyi. All rights reserved.
//

#import "UINavigationItem+Addition.h"

@implementation UINavigationItem (Addition)

- (UIBarButtonItem *)backBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
