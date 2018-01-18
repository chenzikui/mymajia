//
//  CPBuyLotteryCollectionCell.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBuyLotteryCollectionCell.h"

@interface CPBuyLotteryCollectionCell()
{
    IBOutlet UIImageView *_pictureImageView;
    IBOutlet UILabel *_nameLabel;
    
}
@end

@implementation CPBuyLotteryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setLotteryModel:(CPLotteryModel *)lotteryModel
{
    _lotteryModel = lotteryModel;
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:_lotteryModel.fullPicUrlString] placeholderImage:nil];
    _nameLabel.text = _lotteryModel.name;
}

@end
