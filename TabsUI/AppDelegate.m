#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>
@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *detailNavigationController;
@property (nonatomic, strong) UIViewController *emptyViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.splitViewController = (UISplitViewController *)self.window.rootViewController;

    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.splitViewController.delegate = self;

    self.tabBarController = (UITabBarController *)self.splitViewController.viewControllers[0];
    NSAssert([self.tabBarController isKindOfClass:UITabBarController.class], @"");

    self.detailNavigationController = (UINavigationController *)self.splitViewController.viewControllers[1];
    
    self.emptyViewController = self.detailNavigationController.topViewController;

    return YES;
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    UINavigationController *detailNavigationController = (UINavigationController *)secondaryViewController;
    NSAssert([detailNavigationController isKindOfClass:UINavigationController.class], @"");

    if (self.detailNavigationController.topViewController != self.emptyViewController) {
        NSArray *viewControllersToMove = self.detailNavigationController.viewControllers;
        self.detailNavigationController.viewControllers = @[];
        UINavigationController *masterNavigationController = (UINavigationController *)self.tabBarController.selectedViewController;
        NSAssert([masterNavigationController isKindOfClass:UINavigationController.class], @"");
        masterNavigationController.viewControllers = [masterNavigationController.viewControllers arrayByAddingObjectsFromArray:viewControllersToMove];
    }
    return YES;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController
{
    NSAssert(primaryViewController == self.tabBarController, @"");

    UINavigationController *masterNavigationController = (UINavigationController *)self.tabBarController.selectedViewController;
    NSAssert([masterNavigationController isKindOfClass:UINavigationController.class], @"");

    if (masterNavigationController.viewControllers.count > 1) {
        NSArray *viewControllersToMove = [masterNavigationController.viewControllers subarrayWithRange:NSMakeRange(1, masterNavigationController.viewControllers.count - 1)];
        masterNavigationController.viewControllers = @[masterNavigationController.viewControllers.firstObject];
        self.detailNavigationController.viewControllers = viewControllersToMove;
    } else {
        self.detailNavigationController.viewControllers = @[self.emptyViewController];
    }

    return self.detailNavigationController;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender
{
    UINavigationController *masterNavigationController = (UINavigationController *)self.tabBarController.selectedViewController;
    NSAssert([masterNavigationController isKindOfClass:UINavigationController.class], @"");

    if (splitViewController.collapsed) {
        [masterNavigationController pushViewController:vc animated:YES];
    } else {
        self.detailNavigationController.viewControllers = @[vc];
    }
    
    return YES;
}

@end

