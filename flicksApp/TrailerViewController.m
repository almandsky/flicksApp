//
//  TrailerViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TrailerViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MBProgressHUD.h"

@interface TrailerViewController () <UIScrollViewDelegate>

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // NSLog(@"Movie Title is %@", self.movie[@"title"]);
    self.scrollView.delegate = self;
    [self.scrollView setMinimumZoomScale:0.25];
    [self.scrollView setMaximumZoomScale:2];

    // load the image
    NSString *posterPath = self.movie[@"poster_path"];
    // NSLog(@"poster path is %@", posterPath);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *urlString = [@"https://image.tmdb.org/t/p/w150" stringByAppendingString:posterPath];
    NSString *largeImgUrlString = [@"https://image.tmdb.org/t/p/original" stringByAppendingString:posterPath];
    //[self.detailImage setImageWithURL:[NSURL URLWithString:urlString]];
    [self.trailerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                         // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         [self.trailerImageView setAlpha:0.0];
                                         [self.trailerImageView setImage:image];
                                         [UIView animateWithDuration:0.3 animations:^{
                                             [self.trailerImageView setAlpha:1.0];
                                         } completion:^(BOOL finished) {
                                             // NSLog(@"loading the large image %@", largeImgUrlString);
                                             [self.trailerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:largeImgUrlString]]
                                                                     placeholderImage:nil
                                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                                                                  [self.trailerImageView setImage:image];
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

    [self.scrollView setContentSize:self.trailerImageView.image.size];
    [self.scrollView addSubview:self.trailerImageView];
    [self.scrollView setZoomScale:1.2];
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
- (IBAction)onButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.trailerImageView;
}

@end
