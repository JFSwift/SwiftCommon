# SwiftCommon

通过AOP思想解决基类的继承问题。

## Requirements

在AppDelegate手动注入hook方法

```swift
Common.registrationHook()
```

## Usage

##### ViewModel+ViewController

ViewModel

```swift
class ViewModel: NSObjct, CommonViewModel {
  
      func requestNetForData() -> Observable<String> {
        Observable<String>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext("data")
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
        // 绑定错误信号和loading
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
        
    }
    
    /// 获取当前ViewModel进行绑定load
    /// - Returns: description
    func commonGetViewModel() -> CommonViewModel? {
        viewModel
    }
  
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
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.headerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageSize = 1
            return self.requestResultList().trackActivity(self.headerLoading)
        }.bind(to: output.items).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest { [weak self] _ -> Observable<[Int]> in
            guard let self = self else { return Observable.just([]) }
            self.pageSize += 1
            return self.requestResultList().trackActivity(self.footerLoading)
            }.subscribe(onNext: { items in
                output.items.accept(output.items.value + items)
            }).disposed(by: rx.disposeBag)
         
        return output
    }
    
    func requestResultList() -> Observable<[Int]> {
        Observable<[Int]>.create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                observer.onNext([11, 22, 33, 44])
                observer.onCompleted()
            }
            return Disposables.create {
            }
        }.trackError(error).trackActivity(loading)
    }
}

```

TableViewController

```swift
class TableViewController: UITableViewController, CommonListViewController {

    let viewModel = TableViewModel()

    /// 加载View
    func commonViewDidLoad() {
        tableView.register(cellWithClass: UITableViewCell.self)
    }
    
    /// 设置View约束
    func commonLayoutSubViews() {
        
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
    
}

```

## Author

JF, jofox410@gmail.com



## License

SwiftCommon is available under the MIT license. See the LICENSE file for more info.