//
//  NovelViewController.m
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "NovelViewController.h"
#import "Reader.h"
#import "CatalogViewController.h"

@interface NovelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
@property (weak, nonatomic) IBOutlet UILabel *introLb;

@end

@implementation NovelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *coverImgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.novel.coverURL]];
    if (coverImgData) {
        self.coverImg.image = [UIImage imageWithData:coverImgData];
    }
    self.titleLb.text = self.novel.name;
    self.authorLb.text = self.novel.author;
    self.introLb.text = self.novel.intro;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[CatalogViewController class]]) {
        CatalogViewController *vc = (CatalogViewController *)segue.destinationViewController;
        vc.novel = self.novel;
        vc.provider = self.provider;
    }
}


@end
