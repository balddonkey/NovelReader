//
//  ViewController.m
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "ViewController.h"
#import "NovelSearcher.h"
#import "BiqugeProvider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id <NovelProviderType> provider = [[BiqugeProvider alloc] init];
    [provider searchNovel:@"凡人修仙传"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
