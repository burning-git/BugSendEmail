//
//  sendEamil.h
//  bugSendEmail
//
//  Created by gitBurning on 14/11/15.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  发送邮件的 回调
 *
 *  @param success <#success description#>
 *  @param messgae <#messgae description#>
 */



typedef void(^sendSuccessEndBlock)(BOOL success, NSString *messgae);

static NSString * fileNameKey =@"fileName";
static NSString * filePath =@"filePath";
@interface sendEamil : NSObject
@property (copy,nonatomic) NSString       * emailTitle;
@property (copy,nonatomic) NSString       * emailContent;

@property (copy,nonatomic) sendSuccessEndBlock sendSuccessEnd ;
/**
 *  files 是一个自定格式，存储 文件名称和内容
    
 */

@property(copy,nonatomic) NSArray  * files;

+(instancetype)shareEamil;

-(void)sendAEmail;
@end
