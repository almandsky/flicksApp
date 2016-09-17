# Flicks App

This is an Flicks client to display movies currently playing in the theater. The purpose of this project is to develop a basic MVC application and start playing with table views, one of the more complex, but important views in iOS.

Time spent: 25 hours spent in total

## Completed user stories:

 * [x] Required: User can view a list of movies currently playing in theaters from The Movie Database. Poster images must be loaded asynchronously.
 * [x] Required: User can view movie details by tapping on a cell.
 * [x] Required: User sees loading state while waiting for movies API. You can use one of the 3rd party libraries listed on CocoaControls.
 * [x] Required: User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error. See this screenshot for what the error message should look like.
 * [x] Required: User can pull to refresh the movie list.
 * [x] Required: Add a tab bar for Now Playing or Top Rated movies. (high)
 * [x] Required: Implement a UISegmentedControl to switch between a list view and a grid view. (high)
 * [x] Optional: Add a search bar. (med)
 * [x] Optional: All images fade in as they are loading. (low)
 * [x] Optional: For the large poster, load the low-res image first and switch to high-res when complete. (low)
 * [x] Optional: Customize the highlight and selection effect of the cell. (low)
 * [x] Optional: Customize the navigation bar. (low)
 * [x] Optional: Tapping on a movie poster image shows the movie poster as full screen and zoomable. (med)
 * [x] Optional: User can tap on a button to play the movie trailer. (med)

 
## Installation:

Initial setting up the project now.

```
pod install
open flicksApp.xcworkspace
```


Here's a walkthrough of implemented user stories:

<img src='https://github.com/almandsky/flicksApp/raw/master/demo/flicksApp2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

 * The auto layout is taking most of the time to pick up and fine tune the layout for the Movie detail view to achieve the scrolling effect.
 * Passing data between views need the delegate protocol, which is not done yet. 

## License

Copyright 2016 Sky Chen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
