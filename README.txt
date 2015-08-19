Abstract
========

"-viewDidDisappear" is not called when collapsing UISplitViewController unless "nesting" navigation controllers under iOS 8 on iPhone 6+.

Note: It appears iOS 9 fixes this, and we want Apple to confirm that SDK behavior under iOS 9 is indeed correct (and iOS 8 wrong).

The presumed bug
================

Steps:
1. Launch sample app in landscape orientation on iPhone 6+ 8.4 simulator
2. Rotate to portrait, causing split view controller to collapse.
3. Tap "back" to pop the top view controller
Expected: the top view controller's -viewWillDisappear: and -viewDidDisappear: methods are called
Actually: the top view controller's -viewWillDisappear: and -viewDidDisappear: methods are *not* called

We have noticed that under iOS 9 beta 5, -viewWillDisappear: and -viewDidDisappear: *are* called (as expected) and would like for Apple to confirm that this is the correct SDK behavior, so that we can build our app based on that assumption.

Background and Discussion
=========================

With a view controller hierarchy such that the primary view controller of the split view controller is a UITabBarController, we cannot rely on default implementation of -collapseSecondaryViewController:forSplitViewController: to do the collapsing for us.

              +-----------------------+             
              |                       |             
              |  SplitViewController  |             
              |                       |             
              +--+-------------+------+             
                 |             |                    
                 |             |                    
+----------------v------+  +---v-------------------+
|                       |  |                       |
|   Tab Bar Controller  |  |   2' Nav Controller   |
|                       |  |                       |
+----------+------------+  +-----------+-----------+
           |                           |            
           |                           |            
+----------v------------+  +-----------v-----------+
|                       |  |                       |
|   1' Nav Controller   |  |       Detail VC       |
|                       |  |                       |
+----------+------------+  +-----------------------+
           |
           |
+----------v------------+
|                       |
|       Master VC       |
|                       |
+-----------------------+

When collapsing, the detail view controller ("Detail VC") is moved from "2' Nav Controller" to "1' Nav Controller" (by updating the viewControllers properties of both navigation controllers). The result is something like this:

+-----------------------+
|                       |
|  SplitViewController  |
|                       |
+---------+-------------+
          |
          |
+---------v-------------+
|                       |
|  Tab Bar Controller   |
|                       |
+---------+-------------+
          |
          |
+---------v-------------+
|                       |
|   1' Nav Controller   |
|                       |
+---------+-------------+
          |
          +----------------------------+
	      |                            |
+---------v-------------+  +-----------v-----------+
|                       |  |                       |
|        Master VC      |  |      Detail VC        |
|                       |  |                       |
+-----------------------+  +-----------------------+

If user subsequently pops "Detail VC", we find that it is not getting the -viewWillDisappear: or -viewDidDisappear: callbacks. We have found this to be the case, regardless of how the view controllers are moved from the secondary view controller ("2' Nav Controller") into the primary view controller ("1' Nav Controller"), with one exception (below).

The default implementation of -[UINavigationController collapseSecondaryViewController:forSplitViewController:] pushes the *full* secondary view controller into "1' Nav Controller", resulting in something like this:

+-----------------------+                           
|                       |                           
|  SplitViewController  |                           
|                       |                           
+----------+----- ------+                           
           |
           |                                       
+----------v----- ------+                           
|                       |                           
|   Tab Bar Controller  |                           
|                       |                           
+----------+------------+                           
           |                                        
           |                                        
+----------v------------+                           
|                       |                           
|   1' Nav Controller   |
|                       |                           
+----------+------------+                           
           |                                        
           +---------------------------+            
           |                           |            
+----------v------------+  +-----------v-----------+
|                       |  |                       |
|       Master VC       |  |   2' Nav Controller   |
|                       |  |                       |
+-----------------------+  +-----------+-----------+
                                       |            
                                       |            
                           +-----------v-----------+
                           |                       |
                           |       Detail VC       |
                           |                       |
                           +-----------------------+

With this navigation controller "nesting", the disappearance callbacks are called when "Detail VC" is popped. For various reasons, however, we would like to maintain a "flat" stack of view controller's in our UINavigationControllers, and cannot see why our UISplitViewController delegate shouldn't be able to do this, without causing loss of disappearance callbacks.



