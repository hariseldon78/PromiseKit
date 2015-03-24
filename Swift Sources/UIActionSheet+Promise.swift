import UIKit

private class UIActionSheetProxy: NSObject, UIActionSheetDelegate {
    let fulfiller: (Int) -> Void

    init(_ fulfiller: (Int) -> Void) {
        self.fulfiller = fulfiller
        super.init()
        PMKRetain(self)
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        fulfiller(buttonIndex)
        PMKRelease(self)
    }
}


extension UIActionSheet {
    public func promiseInView(view:UIView) -> Promise<Int> {
        let deferred = Promise<Int>.defer()
        delegate = UIActionSheetProxy(fulfiller: deferred.fulfill)
        showInView(view)
        return deferred.promise
    }
}
