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
    
    UIButton *ctaButton = [[UIButton alloc] init];
    [ctaButton setTitle:@"CTA" forState:UIControlStateNormal];
    [ctaButton addTarget:self action:@selector(ctaButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ctaButton];

    ctaButton.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:ctaButton
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                    constant:0];

    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:ctaButton
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0];

    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:ctaButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:100];

    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:ctaButton
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0
                                   constant:50];

    [self.view addConstraints:@[centerX, centerY, width, height]];
}

- (void)ctaButtonTap {
    // MARK: create call tag action
    CinnoxAction *tagAction = [CinnoxAction initTagActionWithTagId:@"YOUR_TAG_ID" contactMethod: CinnoxVisitorContactMethodMessage];
    
    // MARK: create call staff action
    // CinnoxAction *staffAction = [CinnoxAction initStaffActionWithStaffEid:@"YOUR_STAFF_EID" contactMethod: CinnoxVisitorContactMethodMessage];
    
    // MARK: create open directory action
    // CinnoxAction *directoryAction = [CinnoxAction initDirectoryAction];
    
    [[CinnoxVisitorCore current] callToActionWithAction:tagAction completion:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
