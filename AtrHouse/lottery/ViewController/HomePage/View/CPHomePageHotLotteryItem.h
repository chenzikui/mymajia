//
//  CPHomePageHotLotteryItem.h
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPHomePageHotLotteryItemClickAction)(CPLotteryModel *lotteryModel);

@interface CPHomePageHotLotteryItem : UIView

-(instancetype)initWithFrame:(CGRect)frame
                     lottery:(CPLotteryModel*)lottery
                 clickAction:(CPHomePageHotLotteryItemClickAction)action;

@end
