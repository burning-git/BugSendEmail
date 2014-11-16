//
//  ViewController.m
//  findBugSend
//
//  Created by gitBurning on 14/11/16.
//  Copyright (c) 2014年 gitBurning. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {
    [AppDelegate sendEmail];
    
    NSArray *list=@[@"1"];
    //NSLog(@"%@",list[1]);
}

@end
