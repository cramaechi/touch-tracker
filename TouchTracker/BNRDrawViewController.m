//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Chibuikem Amaechi on 7/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface BNRDrawViewController ()

@property (nonatomic, weak) IBOutlet UIVisualEffectView *colorPanelView;

@end

@implementation BNRDrawViewController

- (UIVisualEffectView *)colorPanelView
{
    // If you have not loaded the colorPanelView yet...
    if (!_colorPanelView)
    {
        // Load ColorPanelView.xib
        [[NSBundle mainBundle] loadNibNamed:@"ColorPanelView" owner:self options:nil];
    }
    
    return _colorPanelView;
}

- (void)loadView
{
    // Create a BNRDrawView instance and assign it to the
    // controller's root view
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.colorPanelView.frame = CGRectMake(0, screenRect.size.height, screenRect.size.width, screenRect.size.height);
    
    [self.view addSubview:self.colorPanelView];
}

- (IBAction)makeLineColorOrange:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

- (IBAction)makeLineColorRed:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

- (IBAction)makeLineColorCyan:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

- (IBAction)makeLineColorYellow:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

- (IBAction)makeLineColorMagenta:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

- (IBAction)makeLineColorBlue:(id)sender
{
    BNRDrawView *drawView = (BNRDrawView *)self.view;
    drawView.currentLineColor = (__bridge UIColor *)([sender backgroundColor]);
}

@end
