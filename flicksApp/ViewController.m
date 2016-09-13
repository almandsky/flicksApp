//
//  ViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "TrailerViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;


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
                                                    [self.tableView reloadData];
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

    // pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

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

    if ([segue.identifier isEqualToString:@"detailSegue"]){
        MovieCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MovieDetailViewController *vc = segue.destinationViewController;
        vc.movie = self.movies[indexPath.row];
    } else {
        TrailerViewController *tvc = segue.destinationViewController;
        NSLog(@"sender is %@",sender);
    }
}


@end
