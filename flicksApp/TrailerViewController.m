//
//  TrailerViewController.m
//  flicksApp
//
//  Created by Sky Chen on 9/12/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Movie Title is %@", self.movie[@"title"]);
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

@end
