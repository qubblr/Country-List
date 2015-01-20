//
//  CountryCodesViewController.m
//  Country List
//
//  Created by Vladislav Kartashov on 20/01/15.
//  Copyright (c) 2015 Pradyumna Doddala. All rights reserved.
//

#import "CountryCodesViewController.h"
#import "CountryListDataSource.h"
#import "NSDictionary+CountryCode.h"
#import "CountryCell.h"

#define ViewControllerTitle NSLocalizedString(@"Country", nil);

@interface CountryCodesViewController ()
@property (strong, nonatomic) NSMutableArray *filteredCountryList;
@property (strong, nonatomic) NSArray *initialCountryList;
@property (strong, nonatomic) NSArray *countryList;

@property (strong, nonatomic, readwrite) UISearchDisplayController *searchController;
@end

@implementation CountryCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureSearchBarDisplayController];

    [self.tableView registerClass:[CountryCell class] forCellReuseIdentifier:@"Cell"];
    
    self.countryList = [[[CountryListDataSource alloc] init] countries];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    

}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureNavigationBar {
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.title = ViewControllerTitle;
}

- (void)configureSearchBarDisplayController {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [searchBar sizeToFit];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - Search bar display controller delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString];
    return YES;
}

- (NSMutableArray *)filteredCountryList {
    if (!_filteredCountryList) {
        _filteredCountryList = [[NSMutableArray alloc] initWithCapacity:self.initialCountryList.count];
    }
    return _filteredCountryList;
}

- (void)filterContentForSearchText:(NSString*)searchText {
    [self.filteredCountryList removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", searchText];
    [self.filteredCountryList addObjectsFromArray:[self.initialCountryList filteredArrayUsingPredicate:predicate]];
}

- (void)setCountryList:(NSArray *)countryList {
    _initialCountryList = countryList;
    
    SEL selector = @selector(countryName);
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    
    // Add empty mutable array for each section.
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    // Assigne each object to it's section
    for (id country in countryList) {
        NSInteger sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:country collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:country];
    }
    
    // Sort the rows in each section.
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    _countryList = mutableSections;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    } else {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @[];
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredCountryList count];
    } else {
        return [self.countryList[section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.countryList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *country = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        country = self.filteredCountryList[indexPath.row];
    } else {
        country = self.countryList [indexPath.section][indexPath.row];
    }
    
    cell.textLabel.text = [country valueForKey:kCountryName];
    cell.detailTextLabel.text = [country valueForKey:kCountryCallingCode];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
