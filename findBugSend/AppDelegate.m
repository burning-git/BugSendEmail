//
//  AppDelegate.m
//  findBugSend
//
//  Created by gitBurning on 14/11/16.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import "AppDelegate.h"
#import "sendEamil.h"

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto://suifeng_89@163.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    
    /**
     *  第一种方式,系统发送邮件
     */
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
    /**
     第二种  定义发送邮件
     */
    //
    
}

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    return YES;
}
+(void)sendEmail{
    
    sendEamil *send=[sendEamil shareEamil];
    
    send.emailTitle=@"测试 标题";
    send.emailContent=@"测试内容";
    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
    // NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"test.vcf",fileNameKey,vcfPath,filePath ,nil];
    send.files=[NSArray arrayWithObjects:dict, nil];
    
    
    [send sendAEmail];
    
    send.sendSuccessEnd = ^(BOOL success,NSString *menssage){
        
        if (success) {
            NSLog(@"发送成功");
        }
        else{
            NSLog(@"发送失败");
        }
    };
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
