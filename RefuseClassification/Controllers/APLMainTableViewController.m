/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's primary table view controller showing a list of products.
 */

#import "APLMainTableViewController.h"
#import "APLResultsTableController.h"
#import "APLProduct.h"
#import "MBProgressHUD+YS.h"
@interface APLMainTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

// Our secondary search results table view.
@property (nonatomic, strong) APLResultsTableController *resultsTableController;

// For state restoration.
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end


#pragma mark -

@implementation APLMainTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
    _resultsTableController = [[APLResultsTableController alloc] init];
    _searchController =
		[[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
	
	if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
		// For iOS 11 and later, we place the search bar in the navigation bar.
		self.navigationController.navigationBar.prefersLargeTitles = YES;
		self.navigationItem.searchController = self.searchController;
		
		// We want the search bar visible all the time.
		self.navigationItem.hidesSearchBarWhenScrolling = NO;
	}
	else {
		// For iOS 10 and earlier, we place the search bar in the table view's header.
		self.tableView.tableHeaderView = self.searchController.searchBar;
	}

    // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath is called for both tables.
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    /*	Search is now just presenting a view controller. As such, normal view controller
		presentation semantics apply. Namely that presentation will walk up the view controller
		hierarchy until it finds the root view controller or one that defines a presentation context.
    */
    self.definesPresentationContext = YES;  // Know where you want UISearchController to be displayed.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
    // Restore the searchController's active state.
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

/** Called after the search controller's search bar has agreed to begin editing or when
	'active' is set to YES.
	If you choose not to present the controller yourself or do not implement this method,
	a default presentation is performed on your behalf.

	Implement this method if the default presentation is not adequate for your purposes.
*/
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // Do something before the search controller is presented.
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // Do something after the search controller is presented.
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // Do something before the search controller is dismissed.
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // Do something after the search controller is dismissed.
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
		(UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    APLProduct *product = self.products[indexPath.row];
    [self configureCell:cell forProduct:product];
    
    return cell;
}

/** Here we are the table view delegate for both our main table and filtered table, so we can
	push from the current navigation controller (resultsTableController's parent view controller
	is not this UINavigationController).
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    APLProduct *selectedProduct = (tableView == self.tableView) ?
//        self.products[indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
//
//    APLDetailViewController *detailViewController =
//        [self.storyboard instantiateViewControllerWithIdentifier:@"APLDetailViewController"];
//
//    // Hand off the current product to the detail view controller.
//    detailViewController.product = selectedProduct;
//
//    [self.navigationController pushViewController:detailViewController animated:YES];
//
//    // Note: should not be necessary but current iOS 8.0 bug (seed 4) requires it.
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UISearchResultsUpdating

- (NSMutableArray *)findMatches:(NSArray *)searchItems {
	
	NSMutableArray *andMatchPredicates = [NSMutableArray array];
	for (NSString *searchString in searchItems) {
		/*	Each searchString creates an OR predicate for: name, yearIntroduced, introPrice
		 	Example if searchItems contains "iphone 599 2007":
		 	name CONTAINS[c] "iphone"
		 	name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
		 	name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
		 */
		NSMutableArray *searchItemsPredicate = [NSMutableArray array];
		
		/*	Below we use NSExpression represent expressions in our predicates.
		 	NSPredicate is made up of smaller, atomic parts: two NSExpressions
		 	(a left-hand value and a right-hand value).
		 */
		
		// Name field matching.
		NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
		NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
		NSPredicate *finalPredicate = [NSComparisonPredicate
									   predicateWithLeftExpression:lhs
									   rightExpression:rhs
									   modifier:NSDirectPredicateModifier
									   type:NSContainsPredicateOperatorType
									   options:NSCaseInsensitivePredicateOption];
		[searchItemsPredicate addObject:finalPredicate];
		
		// yearIntroduced field matching.
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
//        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
//        if (targetNumber != nil) {   // searchString may not convert to a number.
//            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//
//            // Price field matching.
//            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//        }
//        NSCompoundPredicate *orMatchPredicates =[NSCompoundPredicate andPredicateWithSubpredicates:searchItemsPredicate];
		// At this OR predicate to our master AND predicate.
        NSCompoundPredicate *orMatchPredicates =
            [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
		[andMatchPredicates addObject:orMatchPredicates];
	}
	return andMatchPredicates;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	
    // Update the filtered array based on the search text.
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.products mutableCopy];
    
    // Strip out all the leading and trailing spaces.
    NSString *strippedString =
		[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Break up the search terms (separated by spaces).
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // Build all the "AND" expressions for each value in the searchString.
    //
	NSMutableArray *andMatchPredicates = [self findMatches:searchItems];
	
    // Match up the fields of the Product object.
    NSCompoundPredicate *finalCompoundPredicate =
        [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // Hand over the filtered results to our search results table.
    APLResultsTableController *tableController =
		(APLResultsTableController *)self.searchController.searchResultsController;
    tableController.filteredProducts = searchResults;
    if(searchResults.count==0){
        [MBProgressHUD showError:@"未检索到有效信息"];
    }
    [tableController.tableView reloadData];
}


#pragma mark - UIStateRestoration

/** We restore several items for state restoration:
	1) Search controller's active state,
	2) search text,
	3) first responder
*/
NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // Encode the view state so it can be restored later.
    
    // Encode the title.
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // Encode the search controller's active state.
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // Encode the first responser status.
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:searchController.searchBar.isFirstResponder forKey:SearchBarIsFirstResponderKey];
    }
    
    // Encode the search bar text.
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // Restore the title.
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
	/*	Restore the active state:
  		we can't make the searchController active here since it's not part of the view
		hierarchy yet, instead we do it in viewWillAppear.
    */
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
	/*	Restore the first responder status:
		We can't make the searchController first responder here since it's not part of the view
		hierarchy yet, instead we do it in viewWillAppear.
    */
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // Restore the text in the search field.
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

@end

