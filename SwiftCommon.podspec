

Pod::Spec.new do |s|
  s.name             = 'WSServiceCommon'
  s.version          = '0.1.0'
  s.summary          = '基类'
  s.description      = <<-DESC
基类协议扩展
                       DESC

  s.homepage         = 'https://gitlab.wsecar.cn/WSServiceCommon'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JFSwift' => 'guojianfeng@wsecar.com' }
  s.platform     = :ios, "10.0"
  s.source           = { :git => 'https://gitlab.wsecar.cn/WSServiceCommon.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.swift_version = '5.0'


  s.source_files = 'RxSwiftDemo/Common/**/*{swift}'

  s.dependency 'RxDataSources'
  s.dependency 'NSObject+Rx'
  s.dependency 'MJRefresh'
  s.dependency 'Aspects'
  s.dependency 'MJRefresh'
  s.dependency 'MBProgressHUD'
  
end
