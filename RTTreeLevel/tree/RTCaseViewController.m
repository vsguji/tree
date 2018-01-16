//
//  RTAuthorViewController.m
//  darongtong
//
//  Created by zy on 2017/8/30.
//  Copyright © 2017年 darongtong. All rights reserved.
//

#import "RTCaseViewController.h"
#import "RTCaseCell.h"

@implementation RTCaseItem
- (instancetype)init {
    self = [super init];
    if (self) {
        _selectFlg = NO;
        _levelTop = NO;
        _willSelectFlag = NO;
        _levelTopOpen = NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.selectFlg forKey:@"selectFlg"];
    [aCoder encodeBool:self.willSelectFlag forKey:@"willSelectFlag"];
    [aCoder encodeBool:self.levelTop forKey:@"levelTop"];
    [aCoder encodeBool:self.levelTopOpen forKey:@"levelTopOpen"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.selectFlg = [aDecoder decodeBoolForKey:@"selectFlg"];
    self.willSelectFlag = [aDecoder decodeBoolForKey:@"willSelectFlag"];
    self.levelTop = [aDecoder decodeBoolForKey:@"levelTop"];
    self.levelTopOpen = [aDecoder decodeBoolForKey:@"levelTopOpen"];
    return self;
}

@end

static NSString *kAuthorIndentity = @"kAuthorIndentity";
@interface RTCaseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImage *_normal;
    UIImage *_selected;
    UIImage *_arrowNormal;
    UIImage *_arrowSelected;
    UITableViewCell *_selectedCell;
}
@property (nonatomic,strong) UITableView *levelTab;
@property (nonatomic,strong) NSIndexPath *oldIndexPath;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,assign) BOOL isAll;
@end

@implementation RTCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航
     [self setLeftTitleNavigationBar:@"取消"];
     [self setRightTitleNavigationBar:@"确定"];
     [self setNavigationBarBackgroundImage:@"tan_navigation"];
    // 树型列表
     self.levelTab = [[UITableView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0, 0, (60), 0)) style:UITableViewStylePlain];
     self.levelTab.dataSource = self;
     self.levelTab.delegate = self;
    self.levelTab.tableFooterView = [UIView new];
    [self.view addSubview:_levelTab];
    // 数据源
     self.items = [NSArray arrayWithArray:[self dataSource]];
    _normal = [UIImage imageNamed:@"circleNormal"];
    _selected = [UIImage imageNamed:@"circleSelected"];
    _arrowNormal = [UIImage imageNamed:@"live_normal"];
    _arrowSelected = [UIImage imageNamed:@"live_down"];
    _isAll = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 弥补动效
   [self setNavigationBarBackgroundImage:@"tan_navigation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicItem = self.items[indexPath.row];
    NSArray *elements = [dicItem allValues][0];
    BOOL isOpen = NO;
    BOOL isSelectFlag = NO;
    BOOL isTopOpen = NO;
     if ([elements isKindOfClass:[NSArray class]] && [elements count] > 1) { // level 1级菜单
         RTCaseItem *objItem = (RTCaseItem *)elements[0];
         isOpen =  objItem.levelTop ? NO : objItem.willSelectFlag ;
         isSelectFlag = objItem.selectFlg;
         isTopOpen = objItem.levelTopOpen;
     }
     else {   // level 2级菜单 或 所有人
        RTCaseItem *item = (RTCaseItem *)elements;
        isOpen = item.willSelectFlag;
        isSelectFlag = item.selectFlg;
     }
    
    RTCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kAuthorIndentity];
    if (cell == nil) {
        cell = [[RTCaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kAuthorIndentity];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indentationLevel = (isOpen == NO) ? 0 : 2;
    cell.origionX  = (isOpen == NO) ? (10) : (40);
    
    NSString *title = [dicItem allKeys][0];
    NSArray *twoParts = [title componentsSeparatedByString:@"|"];
    cell.textLabel.text = twoParts[0];
    cell.detailTextLabel.text = twoParts[1];
    
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] initWithTarget:(self) action:@selector(tapClick:)];
    singTap.numberOfTouchesRequired = 1;
    singTap.numberOfTapsRequired = 1;
    cell.imageView.userInteractionEnabled = YES;
    [cell.imageView addGestureRecognizer:singTap];
    
    cell.imageView.image = (isSelectFlag == NO) ? _normal : _selected;
    if (indexPath.row != 0) {
         cell.accessoryView = [[UIImageView alloc] initWithImage: (isTopOpen) ? _arrowSelected : _arrowNormal];
    }
    else {
        cell.accessoryView = nil;
    }
    [cell layoutSubviews];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *items = self.items;
    NSDictionary *dicItems = items[indexPath.row];
    NSArray *elements = [dicItems allValues][0];
    if ([elements isKindOfClass:[NSArray class]] && [elements count] > 1) { // level 1级菜单
        [self refreshAllSelected:NO];
        NSIndexPath *newIndexPath = indexPath;
        if (self.oldIndexPath && [self.oldIndexPath isEqual:indexPath] == NO) {
            NSDictionary *dicItems = items[self.oldIndexPath.row];
            NSArray *elements = [dicItems allValues][0];
            NSArray *subItems = elements[1];
           [self deleteCell:subItems WithIndexPath:self.oldIndexPath];
            if ([self.oldIndexPath compare:indexPath] == NSOrderedAscending) {
                 newIndexPath = [NSIndexPath indexPathForRow:indexPath.row - subItems.count  inSection:self.oldIndexPath.section];
            }
        }
       
        RTCaseItem *objItem = (RTCaseItem *)elements[0];
        NSArray *subItems = elements[1];
        
         objItem.levelTopOpen =!objItem.levelTopOpen;
         objItem.levelTop = YES;
        
        if (objItem.willSelectFlag == NO ) {
            [self insertNewCell:subItems  WithIndexPath:newIndexPath];
        }
        else {
            [self deleteCell:subItems WithIndexPath:newIndexPath];
        }
        
        if ([self.oldIndexPath isEqual:newIndexPath]){
            self.oldIndexPath = nil;
        }
        else {
            self.oldIndexPath = newIndexPath;
        }
         objItem.willSelectFlag = !objItem.willSelectFlag;
    }
    else {   // level 2级菜单 或 所有人
        RTCaseItem *item = (RTCaseItem *)elements;
        cell.imageView.image =  _selected;
        _selectedCell  = cell;
        item.selectFlg = !item.selectFlg;
        if (indexPath.row == 0) {
             [self refreshAllSelected:!item.selectFlg];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *items = self.items;
    NSDictionary *dicItems = items[indexPath.row];
    NSArray *elements = [dicItems allValues][0];
    if ([elements isKindOfClass:[NSArray class]] && [elements count] > 1) { // level 1级菜单
        NSArray *elements = [dicItems allValues][0];
        RTCaseItem *objItem = (RTCaseItem *)elements[0];
        objItem.selectFlg = NO;
        cell.imageView.image = _normal;
    }
    else { // level 2级菜单
        RTCaseItem *item = (RTCaseItem *)elements;
        item.selectFlg = NO;
        cell.imageView.image = _normal;
    }
}

#pragma mark - 推送给谁看

- (NSArray *)dataSource {
    return @[
             @{@"所有人|所有人可见":[RTCaseItem new]},
             @{@"坛|所有坛友可见":@[[RTCaseItem new],@[
                       @{@"好友坛|所有好友坛坛友可见":[RTCaseItem new]},
                       @{@"八方坛|所有八方坛坛友可见":[RTCaseItem new]},
                       @{@"公关坛|所有公关坛坛友可见":[RTCaseItem new]},
                       @{@"公坛|所有公坛坛友可见":[RTCaseItem new]},
                       @{@"私坛|所有私坛坛友可见":[RTCaseItem new]},
                       @{@"约坛|所有约坛坛友可见":[RTCaseItem new]},
                       @{@"红坛|所有红坛坛友可见":[RTCaseItem new]},
                       @{@"谴颂坛|所有谴颂坛坛友可见":[RTCaseItem new]}
                    ]]
               },
             @{@"个性|所有个性的人可见":@[[RTCaseItem new],@[
                       @{@"家乡|所有家乡的人可见":[RTCaseItem new]},
                       @{@"选定圈子|所有选定圈子的人可见":[RTCaseItem new]},
                       @{@"关注我的|所有关注我的人可见":[RTCaseItem new]},
                       @{@"我关注的|所有我关注的人可见":[RTCaseItem new]},
                       @{@"收藏|所有收藏的人可见":[RTCaseItem new]},
                       @{@"看好|所有看好的人可见":[RTCaseItem new]},
                       @{@"观察|所有观察的人可见":[RTCaseItem new]},
                       @{@"赞|所有赞的人可见":[RTCaseItem new]},
                       @{@"八类资本组合|所有八类资本组合的人可见":[RTCaseItem new]},
                       @{@"不推送摆在店铺/家里|所有不推送摆在店铺/家里的人可见":[RTCaseItem new]},
                    ]]
                }
             ];
}


#pragma mark - 原始状态

- (void)resetLevelTab{
    
    self.items = [self dataSource];
    [self.levelTab reloadData];
    self.oldIndexPath = nil;
}

#pragma mark - 展开

- (void)insertNewCell:(NSArray *)item WithIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        if (indexPath.row > self.items.count - 1) return;
        [self.levelTab beginUpdates];
        NSMutableArray *total = [NSMutableArray array];
        [total addObjectsFromArray:self.items];
        for (NSInteger i = item.count -1 ; i >=0 ; i--) {
            NSDictionary *elementDic = item[i];
            RTCaseItem *element = (RTCaseItem *)[elementDic allValues][0];
            element.willSelectFlag = YES;
            [total insertObject:elementDic atIndex:indexPath.row + 1];
        }
        
        self.items = nil;
        self.items = [total copy];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:item.count];
        for (int i = 1; i <= item.count; i++) {
            @autoreleasepool {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section];
                [indexPaths addObject:newIndexPath];
            }
        }
        [self.levelTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.levelTab insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self.levelTab endUpdates];
    } @catch (NSException *exception) {
        NSLog(@"exception insertCell: %@",exception.description);
        [self resetLevelTab];
   }
}

#pragma mark - 收缩

- (void)deleteCell:(NSArray *)item WithIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        if (indexPath.row > self.items.count - 1) return;
        [self.levelTab beginUpdates];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:item.count];
        [mutableArray addObjectsFromArray:self.items];
        [mutableArray removeObjectsInRange:NSMakeRange(indexPath.row + 1 , item.count)];
        self.items = nil;
        self.items = [NSArray arrayWithArray:mutableArray];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:item.count];
        for (int i = 1; i <= item.count; i++) {
            @autoreleasepool {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section];
                [indexPaths addObject:newIndexPath];
            }
        }
        [self.levelTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.levelTab deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.levelTab endUpdates];
    } @catch (NSException *exception) {
        NSLog(@"exception deleteCell : %@",exception);
        [self resetLevelTab];
    }
}

#pragma mark - 全选

- (void)refreshAllSelected:(BOOL)isAll {
   
    [self.levelTab beginUpdates];
    for (int i = 0 ; i < self.items.count; i++) {
        NSDictionary *item = self.items[i];
        NSObject *objItem = [item allValues][0];
        if ([objItem isKindOfClass:[NSArray class]]) {
            RTCaseItem *item = ((NSArray*)objItem)[0];
             item.selectFlg = isAll;
        }
        else {
             RTCaseItem *item = (RTCaseItem*)objItem;
             item.selectFlg = isAll;
        }
    }
    [self.levelTab reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.levelTab endUpdates];
}

#pragma mark - 点击图标处理
// 1).选择所有人 -- (所有人、坛、个性) ☑️,全关闭
// 2).选择坛或个性 -- 选中父类☑️，关闭当前父类
// 3).选择子菜单 -- 可选单个☑️

- (void)tapClick:(UIGestureRecognizer *)gesture {
    
    UITableViewCell *currentCell = (UITableViewCell *)gesture.view.superview.superview;
    if (currentCell) {
        NSIndexPath *currentIndexPath = [self.levelTab indexPathForCell:currentCell];
        NSArray *items = self.items;
        NSDictionary *dicItems = items[currentIndexPath.row];
        NSArray *elements = [dicItems allValues][0];
        if ([elements isKindOfClass:[NSArray class]] && [elements count] > 1) { // level 1级菜单
            // 已打开的关闭
             [self resetLevelTab];
            NSDictionary *dicItems = self.items[currentIndexPath.row];
            // 当前勾选
            NSArray *elements = [dicItems allValues][0];
            RTCaseItem *objItem = (RTCaseItem *)elements[0];
            currentCell.imageView.image = _selected;
            objItem.selectFlg = !objItem.selectFlg;
        }
        else {  // level 2级菜单 , 或所以人
            if (currentIndexPath.row == 0) {  // 这里只对 所有人生效.
                 [self resetLevelTab];
                 [self refreshAllSelected:!_isAll];
            }
        }
    }
    _selectedCell = currentCell;
}

#pragma mark - 取消

- (void)leftBarItemClicked:(id)sender {
    
    NSLog(@"关闭选择权限");
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [self dismissViewControllerAnimated:vc completion:nil];
}

#pragma mark - 确定

- (void)rightBarItemClicked:(id)sender {
    
    [self leftBarItemClicked:nil];
    if (_selectedCell) {
        NSString *typeName = _selectedCell.textLabel.text;
        if (typeName) {
            int code = [self shareTypeCode:typeName];
            NSLog(@"code : %d",code);
            if (self.block) {
                self.block(typeName, code);
            }
        }
    }
    else {
        NSLog(@"至少选择一个");
    }
}

- (int)shareTypeCode:(NSString *)type{
    
    int code = 0;
    if ([type isEqualToString:@"所有人"]) {
        code = 0;
    }
    else if ([type isEqualToString:@"坛"]){
        code = 1;
    }
    else if ([type isEqualToString:@"好友坛"]){
        code = 2;
    }
    else if ([type isEqualToString:@"八方坛"]){
        code = 3;
    }
    else if ([type isEqualToString:@"公关坛"]){
        code = 4;
    }
    else if ([type isEqualToString:@"公坛"]){
        code = 5;
    }
    else if ([type isEqualToString:@"私坛"]){
        code = 6;
    }
    else if ([type isEqualToString:@"约谈"]){
        code = 7;
    }
    else if ([type isEqualToString:@"红坛"]){
        code = 8;
    }
    else if ([type isEqualToString:@"遣颂坛"]){
        code = 9;
    }
    else if ([type isEqualToString:@"个性"]){
        code = 21;
    }
    else if ([type isEqualToString:@"家乡"]){
        code = 22;
    }
    else if ([type isEqualToString:@"选定圈子"]){
        code = 23;
    }
    else if ([type isEqualToString:@"关注我的"]){
        code = 24;
    }
    else if ([type isEqualToString:@"我关注的"]){
        code = 30;
    }
    else if ([type isEqualToString:@"收藏"]){
        code = 25;
    }
    else if ([type isEqualToString:@"看好"]){
        code = 26;
    }
    else if ([type isEqualToString:@"观察"]){
        code = 27;
    }
    else if ([type isEqualToString:@"赞"]){
        code = 28;
    }
    else if ([type isEqualToString:@"八类资本组合"]){
        code = 29;
    }
    else if ([type isEqualToString:@"不推送摆在店铺/家里"]){
        code = 41;
    }
    return code;
}

- (void)dealloc {
    
    NSLog(@"==退出推荐给谁看==");
}

@end
