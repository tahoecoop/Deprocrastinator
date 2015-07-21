//
//  ViewController.m
//  Deproccrastinator
//
//  Created by Benjamin COOPER on 7/20/15.
//  Copyright (c) 2015 Ben Cooper. All rights reserved.
//

#import "MainViewController.h"
#import "ListItem.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *listItemsArray;
@property (weak, nonatomic) IBOutlet UITextField *toDoTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *priorityTextColors;



@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listItemsArray = [[NSMutableArray alloc] init];

    self.priorityTextColors = [[NSMutableArray alloc] init];

}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listItemsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    ListItem *listItem = [self.listItemsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = listItem.listItemText;
    cell.textLabel.textColor = [self setTextColorWithCompletion:listItem];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ListItem *listem = [self.listItemsArray objectAtIndex:indexPath.row];

    if (listem.isCompleted) {
        listem.isCompleted = NO;
    } else {
        listem.isCompleted = YES;
    }

    cell.textLabel.textColor = [self setTextColorWithCompletion:listem];

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure you want to delete?"  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [tableView beginUpdates];
        [self.listItemsArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];

        [self.tableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [deleteAlert addAction:delete];
    [deleteAlert addAction:cancel];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

}

#pragma mark -Buttons And Swipe
- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    ListItem *listem = [[ListItem alloc] init];
    listem.listItemText = self.toDoTextField.text;
    listem.isCompleted = NO;
    listem.priorityState = 0;

    [self.listItemsArray addObject:listem];

    [self.tableView reloadData];

    self.toDoTextField.text = @"";
    [self.toDoTextField resignFirstResponder];

}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"Done"])
    {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        self.tableView.editing = NO;
    }
    else
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        self.tableView.editing = YES;

    }
}

- (IBAction)onRightSwiping:(UISwipeGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    ListItem *listItem = [self.listItemsArray objectAtIndex:indexPath.row];
    if (listItem.priorityState == 3) {
        listItem.priorityState = 0;
    } else {
        listItem.priorityState++;
    }


    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    cell.textLabel.textColor = [self setTextColorWithPriority:listItem];

}

#pragma mark -Setting Colors

-(UIColor *)setTextColorWithCompletion:(ListItem *)listItem {
    UIColor *color;

    if (listItem.isCompleted) {
        color = [UIColor blueColor];
    } else {
        color = [self setTextColorWithPriority:listItem];
    }
    return color;
}


-(UIColor *)setTextColorWithPriority:(ListItem *)listItem {
    {
        UIColor *color;
        switch (listItem.priorityState) {
            case 0:
                color = [UIColor blackColor];
                break;

            case 1:
                color = [UIColor greenColor];
                break;

            case 2:
                color = [UIColor yellowColor];
                break;

            case 3:
                color = [UIColor redColor];
                break;

            default:
                break;
        }
        
        return color;
        
    }
}




@end
