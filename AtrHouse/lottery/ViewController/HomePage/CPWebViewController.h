//
//  CPWebViewController.h
//  lottery
//
//  Created by wayne on 2017/6/14.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <TOWebViewController/TOWebViewController.h>

#define kTransformSafariWebView @"#_WEBVIEW_#"

@interface CPWebViewController : TOWebViewController

@property(nonatomic,assign)int showHongBaoList;

-(instancetype)cpWebWithURLString:(NSString *)urlString;

@end
