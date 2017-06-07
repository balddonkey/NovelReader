//
//  NovelCatalog.h
//  Novel
//
//  Created by 慧流 on 2017/6/2.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NovelCatalogItem;
@interface NovelCatalog : NSObject

@property (strong, nonatomic) NSString *catalogURL;
@property (strong, nonatomic) NSArray <NovelCatalogItem *> *catalog;

@end
