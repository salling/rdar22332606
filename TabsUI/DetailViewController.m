#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, assign) BOOL isAppeared;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.detailItem;
}

- (void)dealloc
{
    NSAssert(!self.isAppeared, @"-viewDidDisappear: was never called");
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    NSLog(@"<%p>%s<%p>", self, __PRETTY_FUNCTION__, parent);
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    NSLog(@"<%p>%s<%p>", self, __PRETTY_FUNCTION__, parent);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"<%p>%s", self, __PRETTY_FUNCTION__);
    self.isAppeared = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"<%p>%s", self, __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"<%p>%s", self, __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"<%p>%s", self, __PRETTY_FUNCTION__);
    self.isAppeared = NO;
}

@end
