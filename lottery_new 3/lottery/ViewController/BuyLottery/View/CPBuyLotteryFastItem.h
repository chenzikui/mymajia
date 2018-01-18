//
//  CPBuyLotteryFastItem.h
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPBuyLotteryFastItem;

typedef void(^CPBuyLotteryFastItemClickAction)(NSDictionary *buyInfo, BOOL isSelected);
typedef void(^CPBuyLotteryFastItemClickActionTwo)(CPBuyLotteryFastItem *item, NSDictionary *buyInfo, BOOL isSelected);
typedef void(^CPBuyLotteryFastItemClickActionThree)(NSString *infoIndex, BOOL isSelected);


@interface CPBuyLotteryFastItem : UIView

@property(nonatomic,strong)NSDictionary *buyInfo;


-(void)cancelSelected;

+(void)addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                       clickAction:(CPBuyLotteryFastItemClickAction)acion;

+(void)addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
              detailLabelTextColor:(UIColor *)detailLabelTextColor
                       clickAction:(CPBuyLotteryFastItemClickActionTwo)acion;

+(void)addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                         infoIndex:(NSInteger)infoIndex
                       clickAction:(CPBuyLotteryFastItemClickActionThree)acion;

@end
