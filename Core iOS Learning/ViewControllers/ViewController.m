//
//  ViewController.m
//  Core iOS Learning
//
//  Created by v.q on 16/9/12.
//  Copyright © 2016年 Victor Qi. All rights reserved.
//

#import "ViewController.h"
#import "VQSecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goNextVC:(id)sender {
    [self performSegueWithIdentifier:@"goNext" sender:self];
}

@end
