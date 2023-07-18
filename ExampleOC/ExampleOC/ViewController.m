//
//  ViewController.m
//  ExampleOC
//
//  Created by Jimmy on 2023/7/17.
//

#import "ViewController.h"
@import CinnoxVisitorCoreSDK;

@interface ViewController ()

@property (strong, nonatomic) CinnoxVisitorWidget * widget;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.widget = [[CinnoxVisitorWidget alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview: self.widget];
}


@end
