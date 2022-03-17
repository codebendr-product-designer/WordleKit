import UIKit
import WordleKit

public extension WordleKit {
    class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        
        var transitionDuration: TimeInterval = 1.0
        var isPresenting: Bool = true
        
        public init(isPresenting: Bool = true) {
            self.isPresenting = isPresenting
        }
        
        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return transitionDuration
        }
        
        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
            let containerView = transitionContext.containerView
            let fromVC = transitionContext.viewController(forKey: .from)
            let toVC = transitionContext.viewController(forKey: .to)
            let fromView = transitionContext.view(forKey: .from)
            let toView = transitionContext.view(forKey: .to)
            
            let containerFrame = containerView.frame
            var toViewBeginningFrame: CGRect = .zero
            var toViewEndingFrame: CGRect = .zero
            var fromViewEndingFrame: CGRect = .zero
            
            if let destinationView = toView, let presentedVC = toVC, let presentingVC = fromVC {
                containerView.addSubview(destinationView)
                toViewBeginningFrame = transitionContext.initialFrame(for: presentedVC)
                toViewEndingFrame = transitionContext.finalFrame(for: presentedVC)
                fromViewEndingFrame = transitionContext.finalFrame(for: presentingVC)
            }
            
            if isPresenting {
                toViewBeginningFrame.origin = .init(x: 0, y: -containerFrame.size.height)
                toViewBeginningFrame.size = toViewEndingFrame.size
            } else {
                fromViewEndingFrame = .init(x:containerFrame.size.width * 0.5,
                                            y:containerFrame.size.height,
                                            width:0,
                                            height:0);
            }
            
            toView?.frame = toViewBeginningFrame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut) {
                if self.isPresenting {
                    toView?.frame = toViewEndingFrame
                    fromVC?.view.frame = containerFrame
                } else {
                    fromView?.frame = fromViewEndingFrame
                }
            } completion: { done in
                let succeeded = !transitionContext.transitionWasCancelled
                let failedPresenting = (self.isPresenting && !succeeded)
                let didDismiss = (!self.isPresenting && succeeded)
                
                if (failedPresenting || didDismiss) {
                    toView?.removeFromSuperview()
                }
                
                transitionContext.completeTransition(succeeded)
            }
            
        }
    }
}
