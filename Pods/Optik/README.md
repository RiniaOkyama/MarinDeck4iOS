![Optik](Images/Optik_Banner.jpg)

[![Travis build status](https://img.shields.io/travis/prolificinteractive/Optik.svg?style=flat-square)](https://travis-ci.org/prolificinteractive/Optik)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Optik.svg?style=flat-square)](https://img.shields.io/cocoapods/v/Optik.svg)
[![Platform](https://img.shields.io/cocoapods/p/Optik.svg?style=flat-square)](http://cocoadocs.org/docsets/Optik)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/Optik.svg?style=flat-square)](http://cocoadocs.org/docsets/Optik)

## Description

Optik provides a simple viewing experience for a set of images, whether stored locally or remotely.

<img src="https://github.com/prolificinteractive/Optik/blob/master/Images/Optik_Example.gif" width="320px" height="568px" />

## Requirements

* iOS 9.0+
* Xcode 8.1 or later

## Installation

Optik is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod "Optik"
```

## Usage

Optik can be used to display images stored either locally or remotely.

### Displaying Images

#### Local Images

Local images can be displayed by creating an image viewer with an array of images:

```swift
let imageViewer = Optik.imageViewer(
    withImages: [
		UIImage(named: "image1.jpg")!,
		UIImage(named: "image2.jpg")!,
		UIImage(named: "image3.jpg")!
    ]
)

presentViewController(imageViewer, animated: true, completion: nil)
```

#### Remote Images

For remote images, an array of `NSURLs` should be provided - as well as an object conforming to the `ImageDownloader` protocol:

```swift
let imageDownloader = MyImageDownloader()

let imageViewer = Optik.imageViewer(
    withURLs: [
        NSURL(string: "https://somewebsite.com/image1.png")!,
        NSURL(string: "https://somewebsite.com/image2.png")!,
        NSURL(string: "https://somewebsite.com/image3.png")!
    ],
    imageDownloader: imageDownloader
)

presentViewController(imageViewer, animated: true, completion: nil)
```

### Customizing the Image Viewer

#### Dismiss Button

The dismiss button image and position can be customized.

To indicate a custom dismiss button image, provide a `dismissButtonImage` parameter when creating an image viewer:

```swift
let imageViewer = Optik.imageViewer(
    withImages: [
        UIImage(named: "image1.jpg")!
    ],
    dismissButtonImage: UIImage(named: "MyDismissButton")
)
```

To indicate a position for the dismiss button, provide a `dismissButtonPosition`

```swift
let imageViewer = Optik.imageViewer(
    withImages: [
        UIImage(named: "image1.jpg")!
    ],
    dismissButtonImage: UIImage(named: "MyDismissButton"),
    dismissButtonPosition: .TopTrailing
)
```

#### Activity Indicator

When fetching remote images, an activity indicator is displayed while images are loaded. To indicate a custom activity indicator color, provide an `activityIndicatorColor:` parameter when creating an image viewer:

```swift
let imageViewer = Optik.imageViewer(
    withURLs: [
    	NSURL(string: "https://somewebsite.com/image1.png")!
    ],
    imageDownloader: imageDownloader,
    activityIndicatorColor: UIColor.redColor()
)
```

## Contributing to Optik

To report a bug or enhancement request, feel free to file an issue under the respective heading.

If you wish to contribute to the project, fork this repo and submit a pull request. Code contributions should follow the standards specified in the [Prolific Swift Style Guide](https://github.com/prolificinteractive/swift-style-guide).

## License

![prolific](https://s3.amazonaws.com/prolificsitestaging/logos/Prolific_Logo_Full_Color.png)

Copyright (c) 2017 Prolific Interactive

Marker is maintained and sponsored by Prolific Interactive. It may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: ./LICENSE
