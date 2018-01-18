//
//  CPHomePageHotLotteryItem.m
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPHomePageHotLotteryItem.h"

@interface CPHomePageHotLotteryItem ()
{
    CPVoiceButton *_acionButton;
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
}
@property(nonatomic,copy)CPHomePageHotLotteryItemClickAction clickAction;
@property(nonatomic,retain)CPLotteryModel *lottery;
@end

@implementation CPHomePageHotLotteryItem

-(instancetype)initWithFrame:(CGRect)frame
                     lottery:(CPLotteryModel*)lottery
                 clickAction:(CPHomePageHotLotteryItemClickAction)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clickAction = action;
        self.lottery = lottery;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    _acionButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    _acionButton.frame = CGRectMake(0, 0, self.width, self.height);
    [_acionButton addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_acionButton];
    
    CGFloat imgViewOriginX = self.width*0.4/2.0f;
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imgViewOriginX, imgViewOriginX/2.0f, self.width*0.6f, self.width*0.6f)];
    
    if ([self.lottery.num isEqualToString:@"0"]) {
        
        [_iconImageView setImage:[UIImage imageNamed:self.lottery.pic]];
        
    }else{
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.lottery.fullPicUrlString] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    
    
    
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _iconImageView.bottomY, self.width, self.height - _iconImageView.bottomY)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    _nameLabel.text = self.lottery.name;
    
    [self addSubview:_nameLabel];
        
}


-(void)buttonClickAction
{
    if (self.clickAction) {
        self.clickAction(self.lottery);
    }
}


@end
