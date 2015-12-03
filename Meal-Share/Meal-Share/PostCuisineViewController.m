//
//  PostCuisineViewController.m
//  Meal-Share
//
//  Created by Manav Pavitra Singh on 10/21/15.
//  Copyright (c) 2015 SJSU. All rights reserved.
//

#import "PostCuisineViewController.h"
#import "Meal.h"
#import "Meals.h"
#import "AppDelegate.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "ModalViewController.h"
#import "HNKGooglePlacesAutocompleteQuery.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>
#import "CLPlacemark+HNKAdditions.h"


@interface PostCuisineViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) Meal *meal;

@property (nonatomic) BOOL isVegan;
@property (nonatomic) BOOL isVeg;
@property (nonatomic) BOOL isGlutenFree;

@property (nonatomic) BOOL eatHere;
@property (nonatomic) BOOL togo;
@property (nonatomic) BOOL delivery;

@property (nonatomic, strong) UIImage* picture;

@property (nonatomic, strong) NSData* imageData;

@property(nonatomic, strong) NSString* path;

@property (nonatomic, strong) ModalViewController *modalVC;

//autocomplete
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;




@end

@implementation PostCuisineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isVeg = false;
    self.isVegan = false;
    self.isGlutenFree = true;
    
    self.eatHere = false;
    self.togo = false;
    self.delivery = false;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //self.modalVC = [[ModalViewController alloc]init];
    self.modalVC = [storyboard instantiateViewControllerWithIdentifier:@"modal"];
    
   [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
  
    [PostCuisineViewController setPresentationStyleForSelfController:self presentingController:self.modalVC];
    [self presentViewController:self.modalVC animated:YES completion:nil];
    
    
    self.mealAddressTextField.delegate = self;
    self.autoCompleteTableView.delegate = self;
    self.autoCompleteTableView.dataSource = self;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    

   
    [self.autoCompleteTableView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.mealAddressTextField];
    
}

-(void)viewDidAppear:(BOOL)animated
{

}

//-(void)presentController:(UIViewController*)controller fromRootController:(UIViewController*)rootController withSize:(CGSize)size
//{
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
//    [rootController presentModalViewController:nav animated:YES];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        nav.view.superview.backgroundColor = [UIColor clearColor];
//        nav.view.bounds = CGRectMake(0, 0, size.width, size.height);
//    }
//    else
//    {
//        nav.view.superview.bounds = CGRectMake(0, 0, size.width, size.height);
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    return cell;
}
#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    self.mealAddressTextField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  
    return YES;
}

- (void)textFieldDidChange:(NSNotification *)notification {
    // Do whatever you like to respond to text changes here.
    if (self.mealAddressTextField.text.length > 0) {
        [self.autoCompleteTableView setHidden:NO];
        
        
        [self.searchQuery fetchPlacesForSearchQuery: self.mealAddressTextField.text
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                                 
                                             } else {
                                                 self.searchResults = places;
                                                 [self.autoCompleteTableView reloadData];
                                             }
                                         }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
 NSLog(@"textFieldDidBeginEditing");
    
}

- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    [self.autoCompleteTableView setHidden:YES];
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.searchBar setShowsCancelButton:NO animated:YES];
    [self.mealAddressTextField resignFirstResponder];
  
    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
 //   self.mealAddressTextField.text = (NSString *)selectedPlace;
//    [self.autoCompleteTableView setHidden:YES];
    
   [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: self.searchQuery.apiKey
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           [self.autoCompleteTableView setHidden: YES];
                                           self.mealAddressTextField.text = addressString;
//                                           [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
//                                           [self recenterMapToPlacemark:placemark];
                                           [self.autoCompleteTableView deselectRowAtIndexPath:indexPath animated:NO];
                                       }
                                   }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // VCPass the selected object to the new view controller.
   self.modalVC = segue.destinationViewController;
       [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [PostCuisineViewController setPresentationStyleForSelfController:self presentingController:self.modalVC];
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
    
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
}

#pragma mark- Image
- (IBAction)cameraButtonPressed:(UIButton *)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    self.picture = image;
    self.cuisineImage.image = image;
}


-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
        [self dismissModalViewControllerAnimated:YES];


    //Zoomed or scrolled image if picker.editing = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image =  [info objectForKey:UIImagePickerControllerOriginalImage];
        self.cuisineImage.image = image;
            self.picture = image;

    // Get PNG data from following method
    self.imageData =     UIImagePNGRepresentation(image);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    self.imageData = UIImagePNGRepresentation(image);
    [self.imageData writeToFile:self.path atomically:YES];
  

}
#pragma mark- bool options
- (IBAction)vegetarianSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.isVeg = true;
        self.meal.mealVegetarian = @"true";
    }
    else
    {
        self.meal.mealVegetarian = @"false";
    }

}

- (IBAction)eatHereSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.eatHere = true;
        self.meal.mealEatHere = @"true";
    }
    else
    {
        self.meal.mealEatHere = @"false";
    }
}

- (IBAction)togoSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.togo = true;
        self.meal.mealToGo = @"true";
    }
    else
    {
        self.meal.mealToGo = @"false";
    }

}

- (IBAction)isDelivery:(UISwitch *)sender {
    if (sender.on) {
        self.delivery = true;
    }
}
- (IBAction)isVegan:(UISwitch *)sender {
    if (sender.on) {
        self.isVegan = true;
        self.meal.mealVegan = @"true";
    }
    else
    {
        self.meal.mealVegan = @"false";
    }
}

- (IBAction)isGlutenFree:(UISwitch *)sender {
    if (sender.on) {
        self.isGlutenFree = true;
    }
    else
    {
        self.isGlutenFree = false;
    }
    
}

#pragma mark- Post Bar Button
- (IBAction)postBarButtonItem:(UIBarButtonItem *)sender {

    [self persistMeal];
}


#pragma mark - model
- (void) persistMeal
{
    if (!self.meal) {
        self.meal = [[Meal alloc] init];
    }
    
  
    
        self.meal.mealTitle = self.mealTitleTextField.text;
        self.meal.mealAddress = self.mealAddressTextField.text;
        self.meal.mealAvailableSpots = self.numberOfPersonsTextField.text;
        self.meal.mealDescription = self.mealDescriptionTextView.text;
        self.meal.mealStartDateTime = @"2015-10-25T15:00:00Z";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSString *availableDate = [dateFormatter stringFromDate:self.availableUntilDatePicker.date];
    
        self.meal.mealEndDateTime = availableDate;
        self.meal.mealSeller = @"561dfe85eb65f6da3a6de62d";
     self.meal.imagePath= self.path;
    self.meal.price = self.priceTextField.text;
    if (self.isGlutenFree)self.meal.mealGlutenFree = @"true";
        else self.meal.mealGlutenFree = @"false";



    
        //self.location.configuredBySystem = NO;
        
        [[AppDelegate appDelegate].meals persist:self.meal];
    
}

//-(void)persistMultipart
//{
//    NSURL *url = [NSURL URLWithString:@"http://172.16.0.5:8080/upload"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
////    Content-Type: multipart/form-data; boundary=YOUR_BOUNDARY_STRING
//    NSString *boundary = @"YOUR_BOUNDARY_STRING";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    
//    NSMutableData *body = [NSMutableData data];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@.jpg\"\r\n", self.path] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:self.imageData]];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n%@", self.mealTitleTextField.text] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n%d", 1] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:body];
//    
////    NSURLResponse *response;
//  //  NSError *error;
//    
//    //[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
//    
//    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
//        if (!error) {
//            NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
//           // [self parseAndAddMeals:responseArray toArray:self.objects];
//        }
//    }];
//    [dataTask resume];
//    
//    
//}
@end
