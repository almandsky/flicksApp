//
//  ViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import "TrailerViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewControl;
@property BOOL isTableView;


@end

@implementation ViewController

-(void)fetchMovies{
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *endpointURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=", self.endpoint];
    NSString *urlString =
    [endpointURL stringByAppendingString:apiKey];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSArray *tempMovies = responseDictionary[@"results"];
                                                    self.movies = [[NSMutableArray alloc] init];
                                                    for (NSDictionary *movie in tempMovies) {
                                                        if (![movie[@"poster_path"] isEqual:[NSNull null]]) {
                                                            //NSLog(@"found poster_path for title %@", movie[@"title"]);
                                                            [self.movies addObject:movie];
                                                        } else {
                                                            NSLog(@"found empty poster_path for title %@", movie[@"title"]);
                                                        }
                                                    }
                                                    if (self.isTableView) {
                                                        [self.tableView reloadData];
                                                    } else {
                                                        [self.gridView reloadData];
                                                    }
                                                    
                                                    [self.errorView setHidden:YES];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self.errorView setHidden:NO];
                                                }
                                            }];
    [task resume];
}


-(void)refresh:(id)sender {
    [self fetchMovies];
    [sender endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    

    //NSLog(@"the selected view index is %d", self.viewControl.selectedSegmentIndex);
    if (self.viewControl.selectedSegmentIndex == 0) {
        self.isTableView = YES;
        [self.tableView setHidden:NO];
        [self.gridView setHidden:YES];
    } else {
        self.isTableView = NO;
        [self.tableView setHidden:YES];
        [self.gridView setHidden:NO];
    }
    // pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    if (self.isTableView) {
        [self.tableView addSubview:refreshControl];
    } else {
        [self.gridView addSubview:refreshControl];
    }
    

    NSLog(@"fetching the movies!");
    [self fetchMovies];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"view loaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"indexPath is : %ld", (long) indexPath.row);
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.overviewLabel.text = movie[@"overview"];

    //NSLog(@"title is %@", movie[@"title"]);
    NSString *posterPath = movie[@"poster_path"];
    //NSLog(@"poster path is %@", posterPath);

    NSString *urlString =
    [@"https://image.tmdb.org/t/p/w92" stringByAppendingString:posterPath];
    //NSLog(@"url path is %@", urlString);
    /*
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    UIImage *image = [UIImage imageWithData:data];
                                                    [cell.thumbImage setImage:image];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
    */
    [cell.thumbImage setImageWithURL:[NSURL URLWithString:urlString]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSLog(@"identifier is %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"detailSegue"]){
        MovieCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MovieDetailViewController *vc = segue.destinationViewController;
        vc.movie = self.movies[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"griddetailsegue"]) {
        MovieCollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.gridView indexPathForCell:cell];
        MovieDetailViewController *vc = segue.destinationViewController;
        NSLog(@"indexPath row is %ld", indexPath.row);
        NSLog(@"indexPath is %@", indexPath);
        vc.movie = self.movies[indexPath.row];
    } else {
        //TrailerViewController *tvc = segue.destinationViewController;
        NSLog(@"sender is %@",sender);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.overviewLabel.text = movie[@"overview"];
    
    //NSLog(@"title is %@", movie[@"title"]);
    NSString *posterPath = movie[@"poster_path"];
    NSLog(@"poster path is %@", posterPath);
    
    NSString *urlString =
    [@"https://image.tmdb.org/t/p/w92" stringByAppendingString:posterPath];

    [cell.thumbImage setImageWithURL:[NSURL URLWithString:urlString]];
    return cell;

}
- (IBAction)onViewChange:(UISegmentedControl *)sender {

    if (self.viewControl.selectedSegmentIndex == 0) {
        self.isTableView = YES;
        [self.tableView setHidden:NO];
        [self.gridView setHidden:YES];
        [self.tableView reloadData];
    } else {
        self.isTableView = NO;
        [self.tableView setHidden:YES];
        [self.gridView setHidden:NO];
        [self.gridView reloadData];
    }
}


@end
