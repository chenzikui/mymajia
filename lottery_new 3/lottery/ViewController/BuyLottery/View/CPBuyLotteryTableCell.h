//
//  CPBuyLotteryTableCell.h
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBuyLotteryTableCell : UITableViewCell

@property(nonatomic,retain)CPLotteryModel *lotteryModel;

+(CGFloat)cellHeightByLotteryModel:(CPLotteryModel *)lotteryModel
                         cellWidth:(CGFloat)cellWidth;
@end
