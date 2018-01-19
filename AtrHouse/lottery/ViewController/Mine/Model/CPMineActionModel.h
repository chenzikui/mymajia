//
//  CPMineActionModel.h
//  lottery
//
//  Created by wayne on 2017/8/2.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMineActionModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,assign)int identify;

+(instancetype)modelName:(NSString *)name
                    icon:(NSString *)icon
                identify:(int)identify;

@end
