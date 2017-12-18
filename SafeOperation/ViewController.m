//
//  ViewController.m
//  SafeOperation
//
//  Created by LOLITA on 17/12/16.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = nil;
    
//    NSDictionary *dic = @{
//                          @"key":string
//                          };
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@""];
    array[1];
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NextViewController *next = [NextViewController new];
    [self presentViewController:next animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
