//
//  MovieDetailViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"


@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.movie[@"title"];
    self.voteImage.image = [UIImage imageNamed:@"iconmonstr-crown-5-16.png"];
    self.runtimeImage.image = [UIImage imageNamed:@"iconmonstr-time-6-16.png"];

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *urlString = [@"https://image.tmdb.org/t/p/w150" stringByAppendingString:posterPath];
    NSString *largeImgUrlString = [@"https://image.tmdb.org/t/p/w342" stringByAppendingString:posterPath];
    //[self.detailImage setImageWithURL:[NSURL URLWithString:urlString]];
    [self.detailImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                        // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        [self.detailImage setAlpha:0.0];
                                        [self.detailImage setImage:image];
                                        [UIView animateWithDuration:0.3 animations:^{
                                            [self.detailImage setAlpha:1.0];
                                        } completion:^(BOOL finished) {
                                            NSLog(@"loading the large image %@", largeImgUrlString);
                                            [self.detailImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:largeImgUrlString]]
                                                                    placeholderImage:nil
                                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                                                                 [self.detailImage setImage:image];
                                                                             }
                                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                                                 // Your failure handle code
                                                                                 NSLog(@"load image %@ failed.", urlString);
                                                                             }];
                                        }];
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                        // Your failure handle code
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        NSLog(@"load image %@ failed.", urlString);
                                    }];
    

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
                                                    NSObject *runtimeObj = responseDictionary[@"runtime"];
                                                    int hour;
                                                    int mins;
                                                    if ([runtimeObj isEqual: [NSNull null]]) {
                                                        hour = 0;
                                                        mins = 0;
                                                    } else {
                                                        int runtime = [responseDictionary[@"runtime"] intValue];
                                                        hour = runtime / 60;
                                                        mins = runtime % 60;
                                                    }

                                                    NSString * runtimeString = [NSString stringWithFormat:@"%d hr %d mins", hour, mins];
                                                    self.runtimeLable.text = runtimeString;
                                                    NSObject *voteObj = responseDictionary[@"vote_average"];
                                                    float voteAverage;
                                                    if ([voteObj isEqual: [NSNull null]]) {
                                                        voteAverage = 0.0;
                                                    } else {
                                                        voteAverage = [responseDictionary[@"vote_average"] floatValue] * 10;
                                                    }
                                                    self.voteLabel.text = [NSString stringWithFormat:@"%0.f%%", voteAverage];
                                                    // NSLog(@"vote average is %0.f%%@", voteAverage);
                                                    [self.errorView setHidden:YES];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self.errorView setHidden:NO];
                                                }
                                            }];
    [task resume];
    
    NSString *videosURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=", self.movie[@"id"]];
    NSString *requestUrl2 = [videosURL stringByAppendingString:apiKey];
    NSURL *url2 = [NSURL URLWithString:requestUrl2];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    NSURLSession *session2 =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task2 = [session2 dataTaskWithRequest:request2
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"response of movie details are %@", responseDictionary);
                                                    
                                                    //[self.playerViewer loadWithVideoId:@"9qqfMvKxBa0"];
                                                    NSMutableArray *videos = responseDictionary[@"results"];
                                                    NSLog(@"videos are %@", videos);
                                                    NSString *videoKey;
                                                    if (![videos isEqual: [NSNull null]] && videos.count > 0) {
                                                        for (NSDictionary *video in videos) {
                                                            videoKey = video[@"key"];
                                                            //NSString *videoSite = video[@"site"];
                                                            //NSString *videoType = video[@"type"];
                                                            if (![videoKey isEqual: [NSNull null]]) {
                                                                break;
                                                            }
                                                        }
                                                        if (![videoKey isEqual: [NSNull null]]) {
                                                            [self.playerViewer setHidden:NO];
                                                            [self.playerViewer loadWithVideoId:videoKey];
                                                        }
                                                    }
                                                    //[self.errorView setHidden:YES];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    //[self.errorView setHidden:NO];
                                                }
                                            }];
    [task2 resume];
    

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
