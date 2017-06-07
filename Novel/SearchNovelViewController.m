//
//  SearchNovelViewController.m
//  Novel
//
//  Created by 慧流 on 2017/6/5.
//  Copyright © 2017年 慧流. All rights reserved.
//

#import "SearchNovelViewController.h"
#import "BiqugeProvider.h"
#import "Reader.h"
#import "NovelViewController.h"

@interface SearchNovelViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) id <NovelProviderType> provider;

@property (strong, nonatomic) NSArray *novels;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation SearchNovelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
//    [self.tableView addSubview:self.searchController.searchBar];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    self.provider = [[BiqugeProvider alloc] init];
    self.novels = [self.provider searchNovel:@"凡人修仙传"];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%@", searchController.searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.novels = [self.provider searchNovel:searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.novels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    Novel *novel = [self.novels objectAtIndex:indexPath.row];
    cell.textLabel.text = novel.name;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.destinationViewController isKindOfClass:[NovelViewController class]]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Novel *novel = [self.novels objectAtIndex:indexPath.row];
        NovelViewController *vc = (NovelViewController *)segue.destinationViewController;
        vc.novel = novel;
        vc.provider = self.provider;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




@end
