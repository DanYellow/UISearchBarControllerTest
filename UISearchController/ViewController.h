//
//  ViewController.h
//  UISearchController
//
//  Created by Jean-Louis Danielo on 07/11/2014.
//  Copyright (c) 2014 Jean-Louis Danielo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
UISearchControllerDelegate, UISearchResultsUpdating, UINavigationControllerDelegate, UISearchBarDelegate>
{
    UITableViewController *searchResultsController;
    NSArray *datas;
    NSMutableArray *filteredNames;
    
    NSArray *categoryList;
}


@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (nonatomic, strong) UISearchController *searchController;

@end

