//
//  CalendarViewController.m
//  
//
//  Created by John Tunisi on 12/10/15.
//
//

#import "CalendarViewController.h"
#import "CLWeeklyCalendarView.h"
#import "Craft-Swift.h"

@interface CalendarViewController ()<CLWeeklyCalendarViewDelegate>

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.view addSubview:self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
                          CLCalendarDayTitleTextColor : [UIColor whiteColor],
                          CLCalendarSelectedDatePrintColor : [UIColor whiteColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    ScheduleViewController *myClass = ((ScheduleViewController *)self.parentViewController);
    [myClass loadSchedule: date];
}



@end