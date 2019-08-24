# Brew Extension Client

This is a GUI Client of the swift package [Zehua-Chen/brew-extension](https://github.com/Zehua-Chen/brew-extension)

![alt text](https://user-images.githubusercontent.com/31496190/63633455-a9f03400-c5fd-11e9-9620-8a116b5b2909.png)

## Features

- Adding and removing labels
- Intelligent removal of dependencies
- Marking a formulae as protected to prevent unintendded uninstallation

## Solo Project

### What I have learned

- Basic ideas in RxSwift: Observables, Subjects, Drivers
- Present and dismiss view controllers as sheets;
- Using `NSSplitView` and `NSSplitViewController` (add children view
controller, collapse children view controller);
- Using `NSTableView` (selection, supplying view, row actions, ainmate row
changes);
- First responders, and how to send selectors to first responders using both
Interface Builder and Swifth;
- How to create a Core Data stack, and add, fetch and delete entities
- Difference between command line and GUI application (learned by integrating
`Zehua-Chen/brew-extension`)


## Future Work

### TODOs

- [x] Research `Combine`, `RxSwift` to devise a more elegant notification
system
- [x] Refactor the database types to be generic and consistant.
- [ ] Research `Dispatch` and `CoreData`'s multithreading mechanisms to improve
multithreading operations
