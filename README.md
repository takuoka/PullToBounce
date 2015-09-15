# PullToBounce

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/PullToBounce.svg)]()


Animated "Pull To Refresh" Library for UIScrollView.

You can add animated "pull to refresh" action to your UIScrollView, UITableView and UICollectionView.

Inspired by https://dribbble.com/shots/1797373-Pull-Down-To-Refresh

[Objective-C version is here.](https://github.com/luckymore0520/LMPullToBounce)

[Xamarin.iOS version is here.](https://github.com/mattleibow/PullToBounce)

# ScreenShot
![Demo GIF Animation](https://raw.githubusercontent.com/entotsu/PullToBounce/master/demo.gif "Demo GIF Animation")

You can play demo at [appetize.io](https://appetize.io/app/hbj0vawpk8uw9z00838vz5he4g).

# Installation

You can install this to your project via CocoaPods.

```
pod 'PullToBounce'
```


# Usage

## Please Wrap your scroll view

``` swift
// Please wrap your scroll view
tableView.frame = yourFrame
let tableViewWrapper = PullToBounceWrapper(scrollView: tableView)

// Please add wrapper view to your view instead of your scroll view.
bodyView.addSubview(tableViewWrapper)
```
The frame of wrapper will be same as your scrollView.

And the color will be same as your scrollView's background color.


## Event Handler

``` swift
tableViewWrapper.didPullToRefresh = {
    didFinishYourLoading() {
        tableViewWrapper.stopLoadingAnimation()
    }
}
```



# Custom Animation

#### Default arguments of "init" of PullToBounceWrapper


``` swift
init(
  scrollView: UIScrollView, // this is the only required argument
  bounceDuration: CFTimeInterval = 0.8,
  ballSize:CGFloat = 36,
  ballMoveTimingFunc: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints:0.49,0.13,0.29,1.61),
  moveUpDuration: CFTimeInterval = 0.25,
  pullDistance: CGFloat = 96,
  bendDistance: CGFloat = 40,
  didPullToRefresh: (()->())? = nil
)
```
You can use these arguments to customize animation.
