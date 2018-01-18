//
//  CPBuyLotteryManager.m
//  lottery
//
//  Created by 施小伟 on 2017/11/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyLotteryManager.h"

@implementation CPBuyLotteryManager

static CPBuyLotteryManager *manager;

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CPBuyLotteryManager new];
    });
    return manager;
}


+(UIImage *)k3BackgroundImageByNumber:(NSString *)number
{
    int index = [number intValue]-1;
    NSArray *images = @[@"touzi_01_k3",@"touzi_02_k3",@"touzi_03_k3",@"touzi_04_k3",@"touzi_05_k3",@"touzi_06_k3",];
    UIImage *img = [UIImage imageNamed:images[index]];
    return img;
}

@end
