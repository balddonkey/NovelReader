//
//  NovelViewController.h
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Novel;
@protocol NovelProviderType;
@interface NovelViewController : UIViewController

@property (strong, nonatomic) id <NovelProviderType> provider;
@property (strong, nonatomic) Novel *novel;

@end
