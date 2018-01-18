//
//  CPGlobalSettingStore.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPGlobalSettingStore.h"

@interface CPGlobalSettingStore ()
{
    NSString *_openButtonVoice;
}

@end

@implementation CPGlobalSettingStore

static CPGlobalSettingStore *shareStore;

+(CPGlobalSettingStore *)shareStore{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CPGlobalSettingStore *existStore = [CPGlobalSettingStore loadStore];
        shareStore = existStore?existStore:[CPGlobalSettingStore new];
    });
    
    return shareStore;
}

#pragma mark- class method

+(BOOL)saveStore:(CPGlobalSettingStore *)store
{
    @synchronized(self) {
        
        shareStore = store;
        NSData * storeData = [NSKeyedArchiver archivedDataWithRootObject:store];
        NSData * aesStoreData = [storeData AES256EncryptWithKey:loadSettingStoreInfoAES256Key()];
        BOOL isOk = [aesStoreData writeToFile:loadSettingStoreInfoFullPath() atomically:YES];
        return isOk;
    }
    
}

#pragma mark- coding delegate

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_openButtonVoice forKey:@"_openButtonVoice"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        _openButtonVoice = [aDecoder decodeObjectForKey:@"_openButtonVoice"];
        
    }
    return self;
}

#pragma mark- object method

-(void)switchButtonVoiceIsOpen:(BOOL)isOpen
{
    if (isOpen) {
        _openButtonVoice = @"1";
    }else{
        _openButtonVoice = @"0";
    }
    [CPGlobalSettingStore saveStore:self];
}

#pragma mark- getter

-(BOOL)isOpenButtonVoice
{
    if ([_openButtonVoice isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

#pragma mark- AES

NSString * loadSettingStoreInfoFolder(){
    
    return @"settingStore";
}

NSString * loadSettingStoreInfoFullPath(){
    
    return [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:loadSettingStoreInfoFolder()];
}

#pragma mark- AES

NSString * loadSettingStoreInfoAES256Key(){
    
    return @"settingStoreA26K";
}

/**
 *  加载本地储存的用户信息
 *
 *  @return 用户
 */
+(CPGlobalSettingStore *)loadStore
{
    NSData * aesStoreData = [NSData dataWithContentsOfFile:loadSettingStoreInfoFullPath()];
    NSData * storeData = [aesStoreData AES256DecryptWithKey:loadSettingStoreInfoAES256Key()];
    CPGlobalSettingStore * store = [NSKeyedUnarchiver unarchiveObjectWithData:storeData];
    return store;
}

@end
