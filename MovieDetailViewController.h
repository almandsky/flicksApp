//
//  MovieDetailViewController.h
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@property (nonatomic,strong) NSDictionary *movie;

@end