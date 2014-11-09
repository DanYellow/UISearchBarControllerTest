//
//  ViewController.m
//  UISearchController
//
//  Created by Jean-Louis Danielo on 07/11/2014.
//  Copyright (c) 2014 Jean-Louis Danielo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationController.view.backgroundColor = [UIColor grayColor];
//    self.navigationController.navigationBar.translucent = NO;
    //
    //    self.view.backgroundColor = [UIColor blueColor];
    
    
    self.navigationController.navigationBar.translucent = YES;

    
    searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, searchResultsController.tableView.bounds.size.width, searchResultsController.tableView.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor redColor];
        searchResultsController.tableView.backgroundColor = [UIColor redColor];
    searchResultsController.tableView.frame = CGRectMake(0, 10.0, screenWidth, screenHeight);
    searchResultsController.tableView.contentInset = UIEdgeInsetsZero;
    searchResultsController.tableView.hidden = NO;
    
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    _searchController.delegate = self;
//    _searchController.searchBar.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.userInteractionEnabled = YES;
    _searchController.searchBar.frame = CGRectMake(0, 0.0, self.view.bounds.size.width, 50);
    //    [_searchController.navigationController setNavigationBarHidden: NO animated: NO];
    
    
        _searchController.searchBar.showsCancelButton = YES;
    //    _searchController.dimsBackgroundDuringPresentation = NO;
        [_searchController.searchBar sizeToFit];
    _searchController.searchBar.barTintColor = [UIColor grayColor];
  
    //    _searchController.searchBar.backgroundColor = [UIColor grayColor];
    //    _searchController.searchBar.tintColor = [UIColor blackColor];
    //    _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    //    _searchController.searchBar.hidden = YES;
    [_searchController.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    
    
    //    [self.view addSubview:searchResultsController.tableView];
    //    searchResultsController.tableView.tableHeaderView = searchController.searchBar;
    UIView *foo = [[UIView alloc] initWithFrame:CGRectMake(0, 70, screenWidth, 50)];
    foo.backgroundColor = [UIColor redColor];
    
//    [foo addSubview:_searchController.searchBar];
    [self.view addSubview:_searchController.searchBar];
//    [self.view addSubview:searchResultsController.tableView];
    
//    searchResultsController.tableView.tableHeaderView = _searchController.searchBar;
    
//    self.navigationItem.titleView = _searchController.searchBar;
    
//        [self.navigationController.navigationBar addSubview:_searchController.searchBar];
//        self.navigationController.navigationItem.titleView = _searchController.searchBar;
    
    UIView *inputTriggerView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 320, 100)];
    inputTriggerView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:255.0 blue:238.0/255.0 alpha:1];
    inputTriggerView.userInteractionEnabled = YES;
    inputTriggerView.alpha = 1;
    [self.view addSubview:inputTriggerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appearsSearchBar)];
    [inputTriggerView addGestureRecognizer:tap];
    
    //    datas = @[@"max", @"dan", @"ali", @"eli", @"ivan", @"pat", @"bon", @"jovi", @"alex", @"axel", @"rose", @"foo 10"];
    
    filteredNames = [[NSMutableArray alloc] init];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"api" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //    datas = [json valueForKey:@"name"];
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    //    NSArray *yjsonArray = [json filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    //        return [evaluatedObject[@"type"] isEqualToString:@"serie"];
    //    }]];
    
    datas = [[NSArray alloc] initWithArray:json];
    
    //    artistsWithCounts = [NSCountedSet setWithArray:[json valueForKey:@"type"]];
    
    // Sort type in alphabetical order
    categoryList = [[json valueForKeyPath:@"@distinctUnionOfObjects.type"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    
    //    NSPredicate *bobPredicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", @"Breaking Bad"];
    //    NSLog(@"Bobs: %@", [json filteredArrayUsingPredicate:bobPredicate]);
    
    
    _filteredTableData = [[NSMutableDictionary alloc] init];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchController.searchBar becomeFirstResponder];
}


- (void) appearsSearchBar {
    _searchController.searchBar.hidden = NO;
    [searchResultsController.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    [_searchController.searchBar becomeFirstResponder];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [categoryList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //    NSString* key = [[filteredNames valueForKey:@"type"] objectAtIndex:section];
    return [categoryList objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [categoryList objectAtIndex:section];
    NSArray *sectionAnimals = [_filteredTableData objectForKey:sectionTitle];

    return sectionAnimals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.backgroundColor = [UIColor redColor];
//    cell.textLabel.text = (NSString*)[[filteredNames valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"foo description";
    
    NSString *sectionTitle = [categoryList objectAtIndex:indexPath.section];
    NSArray *sectionAnimals = [_filteredTableData objectForKey:sectionTitle];
    NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = animal;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    
    cell.backgroundColor = [UIColor greenColor];
    cell.textLabel.text = [categoryList objectAtIndex:section];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *type = (NSString*)[categoryList objectAtIndex:indexPath.section];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"%@", type);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 35.0;
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *) searchBar {
//    _searchController.searchBar.hidden = YES;
    [searchBar resignFirstResponder];
}


- (void) updateSearchResultsForSearchController:(UISearchController *) searchController {
    
    NSString *searchString = [searchController.searchBar text];
    
    [filteredNames removeAllObjects]; // Can be intern
    [_filteredTableData removeAllObjects];
    
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
////        NSLog(@"Got [%@] string.", evaluatedObject);
//        NSRange range = [evaluatedObject rangeOfString:searchString options:NSCaseInsensitiveSearch];
//        return range.location != NSNotFound;
//    }];
//    
//    NSArray *matches = [datas filteredArrayUsingPredicate:predicate];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", searchString];

    [filteredNames setArray:[datas filteredArrayUsingPredicate:searchPredicate]];
    
    for (int i = 0; i < [[filteredNames valueForKey:@"type"] count]; i++) {
        
        NSPredicate *searchPredica = [NSPredicate predicateWithFormat:@"type = %@", [[filteredNames valueForKey:@"type"] objectAtIndex:i ]];
        
        [_filteredTableData setValue: [[filteredNames filteredArrayUsingPredicate:searchPredica] valueForKey:@"name"] forKey: [[filteredNames valueForKey:@"type"] objectAtIndex:i ]];
    }

    
    [searchResultsController.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchController.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
