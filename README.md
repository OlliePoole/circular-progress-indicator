# Animating Circular Progress View
A view for representing the progress of the user at completing something. 

## Demo
![](http://i.imgur.com/gceR7Rx.gif)

## Requirements
Currently the view depends on the `SnapKit` constraints pod. 

## Adding to your project
1. Download the [latest code version](https://github.com/olliepoole/circular-progress-indicator/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `CircularProgressIndicator.swift` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.

## Usage
**Creation:**
```swift
let statisticsView = CircularProgressIndicator()
```
**Customising the contents:**
```swift
statisticsView.setNumberOfObjectivesCompleted(complete, outOf:total)
```
Where the number passed as the `complete` variable is the current progress and the `outOf` parameter shows the total overall. For example: if you were creating a todo app, and the user had completed 10 items out of 20. You would use the following:

```swift
statisticsView.setNumberOfObjectivesCompleted(10, outOf:20)
```

**Styling the view:**
Methods are available to set the font, attributed text or plain text for the labels of the view.


```swift
// Sets the font of the main label (default: COMPLETED)
func setCompletedTitleFont(font: UIFont)

// Sets the font of the label showing the total completed
func setTotalCompletedFont(font: UIFont)

// Sets the attributed text of the main label (default: COMPLETED)
func setCompletedLabelAttributedText(text: NSAttributedString)

// Sets the regular text of the main label (default: COMPLETED)
func setCompletedLabelText(text: String)
```
