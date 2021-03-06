//
//  MovieDetailViewController.h
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *runtimeImage;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIImageView *voteImage;

@property (nonatomic,strong) NSDictionary *movie;
@property (strong, nonatomic) IBOutlet YTPlayerView *playerViewer;



@end
