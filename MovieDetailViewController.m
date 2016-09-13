//
//  MovieDetailViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.movie[@"title"];

    self.overviewLabel.text = self.movie[@"overview"];
    [self.overviewLabel sizeToFit];

    CGRect frame = self.infoView.frame;
    frame.size.height = self.overviewLabel.frame.size.height + self.overviewLabel.frame.origin.y + 10;
    self.infoView.frame = frame;
    self.detailScrollView.contentSize = CGSizeMake(self.detailScrollView.frame.size.width, 60 + self.infoView.frame.origin.y + self.infoView.frame.size.height);

    // set the release
    // NSLog(@"release date is %@", self.movie[@"release_date"]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *relDate = [dateFormatter dateFromString:self.movie[@"release_date"]];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];

    self.releaseDate.text = [dateFormatter stringFromDate:relDate];

    // set the background image
    NSString *posterPath = self.movie[@"poster_path"];
    NSLog(@"poster path is %@", posterPath);

    NSString *urlString = [@"https://image.tmdb.org/t/p/w342" stringByAppendingString:posterPath];
    [self.detailImage setImageWithURL:[NSURL URLWithString:urlString]];


    // get the movies details
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *movieURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=", self.movie[@"id"]];
    NSString *requestUrl = [movieURL stringByAppendingString:apiKey];
    NSURL *url = [NSURL URLWithString:requestUrl];
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
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    // NSLog(@"response of movie details are %@", responseDictionary);

                                                    int runtime = [responseDictionary[@"runtime"] intValue];
                                                    int hour = runtime / 60;
                                                    int mins = runtime % 60;
                                                    NSString * runtimeString = [NSString stringWithFormat:@"Dur: %d hr %d mins", hour, mins];
                                                    self.runtimeLable.text = runtimeString;
                                                    float voteAverage = [responseDictionary[@"vote_average"] floatValue] * 10;
                                                    self.voteLabel.text = [NSString stringWithFormat:@"Vote: %0.f%%", voteAverage];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
