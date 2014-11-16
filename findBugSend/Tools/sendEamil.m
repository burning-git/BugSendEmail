//
//  sendEamil.m
//  bugSendEmail
//
//  Created by gitBurning on 14/11/15.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import "sendEamil.h"
#import "NSData+Base64Additions.h"
#import "SKPSMTPMessage.h"


#define KfromEamil    @"fromEmail"
#define ktoEmail      @"toEmail"
#define krelayHost    @"relayHost"
#define klogin        @"login"
#define kpass         @"pass"
#define krequiresAuth @"requiresAuth"
#define kwantsSecure  @"wantsSecure"
@interface sendEamil()<SKPSMTPMessageDelegate>
@end

@implementation sendEamil

+(instancetype)shareEamil{
    static sendEamil *email=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        email=[[sendEamil alloc] init];
    });
    return email;
    
}
-(instancetype)init{
    if (self == [super init]) {
        [self initializeEamil];
    }
    return self;
}


-(void)initializeEamil{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaultsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"邮箱账号", KfromEamil,
                                               @"发送邮箱",ktoEmail,
                                               @"smtp.email.com", krelayHost,
                                               @"邮箱账号", klogin,
                                               @"邮箱密码", kpass,
                                               [NSNumber numberWithBool:YES], krequiresAuth,
                                               [NSNumber numberWithBool:YES], kwantsSecure, nil];
    
    
    
    [userDefaults registerDefaults:defaultsDictionary];
}

-(void)sendAEmail{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"fromEmail"];
    
    testMsg.toEmail = [defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"relayHost"];
    
    testMsg.requiresAuth = [[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"login"];
        
        testMsg.pass = [defaults objectForKey:@"pass"];
        
    }
    
    testMsg.wantsSecure = [[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!
    
    /**
     *  titile
     */
    testMsg.subject = self.emailTitle?self.emailTitle:@"";
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
     testMsg.delegate = self;
    
    /**
     *  内容填写
     */
    NSString * emailContentStr=self.emailContent?self.emailContent:@"";
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain;charset=UTF-8",kSKPSMTPPartContentTypeKey,
                               emailContentStr,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    
    NSMutableArray * fileAndContent=[NSMutableArray array];
    [fileAndContent addObject:plainPart];
    
    if (self.files.count!=0) {

       [self.files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           if ([obj isKindOfClass:[NSDictionary class]]) {
               NSString *fileNameStr = obj[fileNameKey];
               NSData   *fileData    = [NSData dataWithContentsOfFile:obj[filePath]];
               
               NSLog(@"fileNameStr%@",fileNameStr);
               NSAssert(fileNameStr != nil, @"文件名错误");
               NSAssert(fileData !=nil, @"文件错误");
               
               //@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.vcf\""
               NSString *kSKPSMTPPartContentTypeKeyStr=[NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"",fileNameStr];
               NSString *kSKPSMTPPartContentDispositionKeyStr=[NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"",fileNameStr];
               
               NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:kSKPSMTPPartContentTypeKeyStr,kSKPSMTPPartContentTypeKey,kSKPSMTPPartContentDispositionKeyStr,kSKPSMTPPartContentDispositionKey,[fileData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
               
               [fileAndContent addObject:vcfPart];
               
           }
       }];
        
    }
    
    
    
    
    
    
    
    
    
    testMsg.parts = [fileAndContent copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testMsg send];
    });

}



#pragma mark-----SKPSMTPMessageDelegate
- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"delegate - message sent");
    self.sendSuccessEnd(YES,nil);
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error: %@, %@", [error code], [error localizedDescription]];
    
    
    NSLog(@"delegate - error(%ld): %@", [error code], [error localizedDescription]);
    self.sendSuccessEnd(NO,[error localizedDescription]);
}
@end
