#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:DetailViewController.class]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [(id)[segue destinationViewController] setDetailItem:[NSString stringWithFormat:@"Item %ld", (long)indexPath.item]];
    }
}

@end
