//
//  CPBuyLotterySectionView.h
//  lottery
//
//  Created by wayne on 2017/9/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    //快捷下注
    CPBuyLotteryBetFast         = 0,
    
    //自选下注
    CPBuyLotteryBetCustom       = 1,
    
    //六 合 彩合肖
    CPBuyLotteryBetForHeXiao    = 2,
    
    //连肖连尾
    CPBuyLotteryBetForLianXiaoWei    = 3,
    
    //六 合 彩的横向排布视图
    CPBuyLotteryBetForLHCHorizontalViewStyle    = 4

    
} CPBuyLotteryBetType;

@protocol CPBuyLotterySectionViewDelegate <NSObject>

-(void)buyLotteryBetFastBuyInfo:(NSDictionary *)buyInfo
                    sectionName:(NSString *)sectionName
                          isBuy:(BOOL)isBuy;

-(void)buyLotteryBetCustomBuyInfo:(NSDictionary *)buyInfo
                      sectionName:(NSString *)sectionName
                            value:(NSString *)value;


-(void)clickShowDetailBuyInfo;

-(NSDictionary *)betNameDictionary;

#pragma mark- 特殊处理

-(void)buyHeXiaoWithInfos:(NSArray *)infos
                    value:(NSString *)value
                   playId:(NSString *)playId;

-(NSArray *)heXiaoPlayDetailInfoList;

@end

@interface CPBuyLotterySectionView : UIView

@property(nonatomic,strong)NSDictionary *buySectionInfo;

@property(nonatomic,assign)NSInteger lianXiaoWeiMinSelectedCount;

-(id)initWithFrame:(CGRect)frame
    buySectionInfo:(NSDictionary *)buySectionInfo
           betType:(CPBuyLotteryBetType)betType
          delegate:(id<CPBuyLotterySectionViewDelegate>)delegate;


#pragma mark- 连肖连尾
//连肖连尾
-(BOOL)isSelectedLianXiaoWeiLotterys;
-(BOOL)isVerifySelectedLianXiaoWeiLotterys;
-(NSArray *)betValuesInfo;

@end
