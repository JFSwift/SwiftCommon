# SwiftCommon

通过AOP思想解决基类的继承问题。减少新建控制器及ViewModel中的重复代码。

### 目录介绍

```
Commom
|————Common - 启动关键代码
|————Extensions - 相关扩展
|		|		Extension - 扩展兼容协议基类
|		|		MJRefresh+Rx - 上下拉刷新相关Rx扩展及UI扩展
|		|		MBProgressHUD+Rx - 加载框Rx扩展
|		|		NSObject+Swizzle - Hook相关
|		|		UIViewController+Ext - 基类相关逻辑代码
|————ViewController - ViewController相关协议
|		|		CommonListViewController - 基础列表控制器协议
|		|		CommonViewController - 基础控制器协议
|————ViewModel - viewModel相关协议
|		|		CommonViewModel - 基础ViewModel协议
|		|		ViewModelType - ViewModel标准输入输出协议
|		|		CommonListViewModel - 基础列表ViewModel协议
|		|		Utility - Rx错误扩展和活动监测
|		|			|		ErrorTracker - 错误跟踪
|		|			|		ActivityIndicator - loading活动监测
```



### Installation

`pod 'SwiftCommon'`

## Requirements

在AppDelegate手动注入hook方法

```swift
Common.registrationHook()
```

## Usage

##### 基础控制器

SimpleCommonViewController

```
/// 遵循CommonViewController协议
class SimpleCommonViewController: UIViewController, CommonViewController {

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // 加载视图
    func commonViewDidLoad() {
        view.addSubview(contentLabel)
    }

    // 视图约束
    func commonLayoutSubViews() {
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 业务逻辑
    func commonFunctionalBusiness() {

    }

    // MARK: - Request

    // MARK: - Event Response

    // MARK: - lazy
}
```



##### ViewModel+ViewController

ViewModel

```swift
class ViewModel: NSObject, CommonViewModel, ViewModelType {

    struct Input {
        let request: Observable<Void>
    }

    struct Output {
        /// 请求的结果
        let result = BehaviorRelay<String>(value: "")
    }

    /// 处理页面绑定
    /// - Parameter input: 输入源
    /// - Returns: 输出源
    func transform(input: Input) -> Output {
        let output = Output()
        input.request.flatMapLatest { [weak self] _ -> Observable<String> in
            guard let self = self else { return Observable.just("") }
            return self.requestNetForData()
        }.bind(to: output.result).disposed(by: rx.disposeBag)
        return output
    }

    func requestNetForData() -> Observable<String> {
        Observable<String>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext("请求的返回结果 \(arc4random() % 10)")
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
    }

}
```

ViewController

```swift
class ViewController: UIViewController, CommonViewControllerFull {

    let viewModel = ViewModel()

    /// 加载View
    func commonViewDidLoad() {

    }
    
    /// 设置View约束
    func commonLayoutSubViews() {
        
    }
    
    /// 绑定ViewModel
    func commonBindViewModel() {
      	let input = ViewModel.Input(request: request)
        let output = viewModel.transform(input: input)
        output.result.bind(to: contentLabel1.rx.text).disposed(by: rx.disposeBag)
    }
    
    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }
  
    // MARK: - lazy

    let request: PublishSubject<Void> = PublishSubject()

    let viewModel = ViewModel()

}
```

ViewController和ViewModel提供了默认加载框只需在ViewModel的请求中加入以下代码

`trackActivity(loading)`



##### ViewModel+ListViewCotroller



ViewModel

```swift
class TableViewModel: NSObject, CommonListViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }

    struct Output {
        let items = BehaviorRelay<[Int]>(value: [])
    }

    /// 处理页面绑定
    /// - Parameter input: 输入源
    /// - Returns: 输出源
    func transform(input: Input) -> Output {
        let output = Output()
        input.headerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageNow = 1
            return self.requestResultList().trackActivity(self.headerLoading)
        }.bind(to: output.items).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageNow += 1
            return self.requestResultList().trackActivity(self.footerLoading)
            }.subscribe(onNext: { items in
                output.items.accept(output.items.value + items)
            }).disposed(by: rx.disposeBag)
        return output
    }

    func requestResultList() -> Observable<[Int]> {
        Observable<[Int]>.create { [weak self] observer in
            let disposables = Disposables.create()
            guard let self = self else { return disposables }
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext(
                    Array(1...20)
                )
                if self.pageNow == 1 {
                    self.resetRefreshStatus(action: .stopHeaderRefresh(hiddenFooter: false))
                } else {
                    self.resetRefreshStatus(action: .stopFooterRefresh(showMore: false))
                }
                observer.onCompleted()
            }
            return disposables
        }.trackError(error).trackActivity(loading)
    }

}
```

TableViewController

```swift
class SimpleCommonListController: UIViewController, CommonListViewController {

    // MARK: - Life Cycle

    /// 加载View
    func commonViewDidLoad() {
        view.addSubview(tableView)
        tableView.register(cellWithClass: UITableViewCell.self)
        tableView.common.addRefreshHeader { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        }
        tableView.common.addRefreshFooter { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        }
    }

    /// 设置View约束
    func commonLayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 业务逻辑
    func commonFunctionalBusiness() {

    }

    /// 绑定ViewModel
    func commonBindViewModel() {
        let input = TableViewModel.Input(headerRefresh: headerRefreshTrigger, footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        output.items.bind(to: tableView.rx.items) { tableView, _, element in
            let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
            cell.textLabel?.text = "\(element)"
            return cell
        }.disposed(by: rx.disposeBag)
        headerRefreshTrigger.onNext(())
    }

    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }

    /// 返回当前listView
    /// - Returns: description
    func commonListGetListView() -> UIScrollView? {
        tableView
    }

    // MARK: - lazy

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    var viewModel = TableViewModel()

}
```

## Author

JF, jofox410@gmail.com



## License

SwiftCommon is available under the MIT license. See the LICENSE file for more info.