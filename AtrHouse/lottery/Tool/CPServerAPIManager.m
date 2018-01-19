//
//  CPServerAPIManager.m
//  lottery
//
//  Created by wayne on 2017/8/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPServerAPIManager.h"

NSString * const CPSerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const CPSerVerAPINameForAPIMain              = @"https://cp89.c-p-a-p-p.net/ios2";
//NSString * const CPSerVerAPINameForAPIMain              = @"https://api.00CP55.COM/ios2";
//NSString * const CPSerVerAPINameForAPIMain              = @"https://api.9595055.com/ios2";
//NSString * const CPSerVerAPINameForAPIMain              = @"http://192.168.1.28:8080/lottery_admin/ios2";


NSString * const CPSerVerAPINameForAPIHall              = @"/api/hall";
NSString * const CPSerVerAPINameForAPIIndex             = @"/api/index";
NSString * const CPSerVerAPINameForAPILoginSubmit       = @"/api/login/submit";

NSString * const CPSerVerAPINameForAPINoticeNoTip       = @"/api/notice/noTip";


NSString * const CPSerVerAPINameForAPIDraw              = @"/api/draw";
NSString * const CPSerVerAPINameForAPIRegistPreInfo     = @"/api/reg/pre";
NSString * const CPSerVerAPINameForAPIKefu              = @"/api/kefu";
NSString * const CPSerVerAPINameForAPIRegLaw            = @"/api/reg/law";
NSString * const CPSerVerAPINameForAPIRegist            = @"/api/reg/submit";
NSString * const CPSerVerAPINameForAPIFreeUserCode      = @"/api/free/userCode";
NSString * const CPSerVerAPINameForAPIFreeUserSubmit    = @"/api/free/submit";
NSString * const CPSerVerAPINameForAPIPasswordVerify    = @"/api/password/verify";
NSString * const CPSerVerAPINameForAPIPasswordReset     = @"/api/password/reset";

//type:0余额+未读消息数 1余额
NSString * const CPSerVerAPINameForAPIUserAmount        = @"/api/user/amount";
NSString * const CPSerVerAPINameForAPIUserSpread        = @"/api/user/spread";
NSString * const CPSerVerAPINameForAPIUserSpreadList    = @"/api/user/spreadList";


NSString * const CPSerVerAPINameForAPIUserCheckin       = @"/api/user/checkin";
NSString * const CPSerVerAPINameForAPIUserCheckinList   = @"/api/user/checkinList";
NSString * const CPSerVerAPINameForAPIUsercheckinSubmit       = @"/api/user/checkinSubmit";

NSString * const CPSerVerAPINameForAPIUserMsg       = @"/api/user/msg";
NSString * const CPSerVerAPINameForAPIUserMsgDetail       = @"/api/user/msgDetail";


NSString * const CPSerVerAPINameForAPIUserBetList       = @"/api/user/betList";
NSString * const CPSerVerAPINameForAPIUserBetDetail       = @"/api/user/betDetail";

NSString * const CPSerVerAPINameForAPIUserAccountList       = @"/api/user/accountList";

NSString * const CPSerVerAPINameForAPIUserRechargeList      = @"/api/user/rechargeList";
NSString * const CPSerVerAPINameForAPIUserRechargeDetail      = @"/api/user/rechargeDetail";


NSString * const CPSerVerAPINameForAPIUserWithdrawList      = @"/api/user/withdrawList";
NSString * const CPSerVerAPINameForAPIUserWithdrawDetail     = @"/api/user/withdrawDetail";

NSString * const CPSerVerAPINameForAPISetting     = @"/api/setting";


NSString * const CPSerVerAPINameForAPISettingLoginPasswd     = @"/api/setting/loginPasswd";

NSString * const CPSerVerAPINameForAPISettingAboutUs     = @"/api/setting/aboutUs";

NSString * const CPSerVerAPINameForAPILogout     = @"/api/logout";


NSString * const CPSerVerAPINameForAPISettingGetQa     = @"/api/setting/getQa";
NSString * const CPSerVerAPINameForAPISettingQaSubmit     = @"/api/setting/qaSubmit";


NSString * const CPSerVerAPINameForAPISettingIsWithdrawPasswdSet     = @"/api/setting/isWithdrawPasswdSet";
NSString * const CPSerVerAPINameForAPISettingWithdrawPasswd     = @"/api/setting/withdrawPasswd";


NSString * const CPSerVerAPINameForAPISettingGetBank    = @"/api/setting/getBank";
NSString * const CPSerVerAPINameForAPISettingBindBank     = @"/api/setting/bindBank";


NSString * const CPSerVerAPINameForAPITrendTypeList     = @"/api/trend/typeList";


NSString * const CPSerVerAPINameForAPIUserWithdraw     = @"/api/user/withdraw";
NSString * const CPSerVerAPINameForAPIUserWithdrawSubmit     = @"/api/user/withdrawSubmit";

NSString * const CPSerVerAPINameForAPIUserRecharge     = @"/api/user/recharge";


NSString * const CPSerVerAPINameForAPIUserRbankList     = @"/api/user/rbankList";

NSString * const CPSerVerAPINameForAPIUserRonlineList     = @"/api/user/ronlineList";
NSString * const CPSerVerAPINameForAPIUserRqqpayList     = @"/api/user/rqqpayList";
NSString * const CPSerVerAPINameForAPIUserRotherList     = @"/api/user/rotherList";

NSString * const CPSerVerAPINameForAPIUserRwechatList     = @"/api/user/rwechatList";
NSString * const CPSerVerAPINameForAPIUserRalipayList     = @"/api/user/ralipayList";

NSString * const CPSerVerAPINameForAPIUserRbankNext     = @"/api/user/rbankNext";
NSString * const CPSerVerAPINameForAPIUserRbankSubmit     = @"/api/user/rbankSubmit";

NSString * const CPSerVerAPINameForAPIUserRqqpayNext     = @"/api/user/recharge/qqpayNext";
NSString * const CPSerVerAPINameForAPIUserRotherNext     = @"/api/user/recharge/otherNext";

NSString * const CPSerVerAPINameForAPIUserRwechatScanNext     = @"/api/user/rwechatScanNext";
NSString * const CPSerVerAPINameForAPIUserRalipayScanNext     = @"/api/user/ralipayScanNext";

NSString * const CPSerVerAPINameForAPIUserWechatNext     = @"/api/user/recharge/wechatNext";
NSString * const CPSerVerAPINameForAPIUserAlipayNext     = @"/api/user/recharge/alipayNext";


NSString * const CPSerVerAPINameForAPIUserRalipayBankNext     = @"/api/user/ralipayBankNext";
NSString * const CPSerVerAPINameForAPIUserWechatBankNext     = @"/api/user/rwechatBankNext";

NSString * const CPSerVerAPINameForAPIUserRalipayBankSubmit     = @"/api/user/ralipayBankSubmit";
NSString * const CPSerVerAPINameForAPIUserWechatBankSubmit     = @"/api/user/rwechatBankSubmit";


NSString * const CPSerVerAPINameForAPIUserRwechatScanSubmit     = @"/api/user/rwechatScanSubmit";
NSString * const CPSerVerAPINameForAPIUserRalipayScanSubmit     = @"/api/user/ralipayScanSubmit";


NSString * const CPSerVerAPINameForAPIBuy               = @"/api/buy";

NSString * const CPSerVerAPINameForAPIBetSubmit         = @"/api/bet/submit";

NSString * const CPSerVerAPINameForAPISendMessageCode       = @"/api/send/messageCode";
NSString * const CPSerVerAPINameForAPISendSubmit            = @"/api/send/submit";


//ronlineList
//rqqpayList
//rwechatList
//ralipayList


@implementation CPServerAPIManager

@end
