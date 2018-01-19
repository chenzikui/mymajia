//
//  CPLongPressSaveImageView.m
//  lottery
//
//  Created by 施小伟 on 2017/11/15.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLongPressSaveImageView.h"

@interface CPLongPressSaveImageView()<UIActionSheetDelegate>

@end

@implementation CPLongPressSaveImageView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addLongPressAction];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addLongPressAction];
}

-(void)addLongPressAction
{
    self.userInteractionEnabled = YES;
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    [self addGestureRecognizer:longPress];
    //判定为长按手势 需要的时间
    longPress.minimumPressDuration = 0.5;
    //判定时间,允许用户移动的距离
    longPress.allowableMovement = 100;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{

    //长按手势
    if (longPress.state == UIGestureRecognizerStateBegan && self.image) {
        UIActionSheet  *actionSheet = [[UIActionSheet alloc]initWithTitle:@"save" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save pictures to iphone",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Save pictures to iphone"]) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    if (!error) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"Save picture success"];
    }else{
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"Save picture failure"];
    }
}


@end
