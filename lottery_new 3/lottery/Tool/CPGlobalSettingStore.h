//
//  CPGlobalSettingStore.h
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPGlobalSettingStore : NSObject

@property(nonatomic,assign,readonly)BOOL isOpenButtonVoice;

-(void)switchButtonVoiceIsOpen:(BOOL)isOpen;


@end
