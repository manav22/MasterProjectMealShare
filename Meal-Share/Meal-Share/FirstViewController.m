//
//  FirstViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/14/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "FirstViewController.h"
#import "Meals.h"
#import "AppDelegate.h"
#import "Meal.h"
#import "RequestOrderViewController.h"

@interface FirstViewController () <MealModelDelegate>
@property (strong, nonatomic) Meals *meals;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

 
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self meals].delegate = self;
    self.tabBarController.navigationItem.hidesBackButton = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Model
- (void)modelUpdated
{
    [self.tableView reloadData];
}

- (Meals*) meals
{
    return [AppDelegate appDelegate].meals;
}

#pragma mark- Table View DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self meals].objects count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    self.meals = [self meals];
    Meal *meal = self.meals.objects[indexPath.row];
    
    cell.textLabel.text = meal.mealTitle;
   // cell.detailTextLabel.text = meal.mealAddress;
    
    return cell;
    
}
#pragma mark- Table View Delegate
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toRequestOrderViewController" sender:indexPath];
}

#pragma mark- Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.destinationViewController isKindOfClass:[RequestOrderViewController class]]) {
            RequestOrderViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *path = sender;
            Meal *selectedMeal;
            selectedMeal = self.meals.objects[path.row];
            targetViewController.selectedMeal = selectedMeal;
        }
    }
    
}



@end
