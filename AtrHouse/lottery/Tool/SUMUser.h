//
//  SUMUser.h
//  sumei
//
//  Created by wayne on 16/11/6.
//  Copyright © 2016年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUMUserTokenInfo : NSObject

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *isLogin;
@property(nonatomic,copy)NSString *memberCode;
@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *errorMsg;
@property(nonatomic,copy)NSString *type;


@property(nonatomic,assign)BOOL hasLogin;

@end

@interface SUMUser : NSObject


@property(nonatomic,assign,readonly)BOOL isLogin;
@property(nonatomic,copy,readonly)NSString *domainString;
@property(nonatomic,copy,readonly)NSString *token;
@property(nonatomic,assign,readonly)BOOL isTryPlay;
@property(nonatomic,retain,readonly)SUMUserTokenInfo *tokenInfo;


/**
 当前是否是数字盘
 */
@property(nonatomic,assign)BOOL buyLotteryDetailHasNumberPan;


+(SUMUser *)shareUser;
+(void)checkUpdateNewestVersion;
+(void)addWebCookies;


-(NSString *)fetchLoginToken;
-(void)addMainDomainString:(NSString *)domainString;
-(void)addToken:(NSString *)token;
-(void)logout;


@end



