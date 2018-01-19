//
//  CPTimeManager.h
//  lottery
//
//  Created by wayne on 2017/10/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTimeManager : NSObject

@property(nonatomic,assign,readonly)NSTimeInterval beijingTiemDistance;


+(CPTimeManager *)shareTimeManager;
-(void)reloadBeiJingTime;



@end
