import UIKit
import Animations
import WordleKit

public extension WordleKit {
    class CardViewController: UIViewController {
        
#warning("add UIVisualEffectView for when view is expanded?")
        private lazy var cardView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.systemGray6.cgColor
            view.backgroundColor = .secondarySystemBackground
            view.layer.cornerRadius = 30
            return view
        }()
        
        private lazy var handleView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemGray4
            view.layer.cornerRadius = 3
            return view
        }()
        
        private var totalScores = 0
        private let panRecognizer = InstantPanGestureRecognizer()
        private var animator = UIViewPropertyAnimator()
        private var isOpen = false
        private var animationProgress: CGFloat = 0
        private var closedTransform = CGAffineTransform.identity
        
        public override func viewDidAppear(_ animated: Bool) {
            self.cardView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 1.2)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
                self.cardView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.6)
            }
        }
        
        init(totalScores: Int) {
            self.totalScores = totalScores
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            let label = UILabel()
            label.text = "\(totalScores)🎉"
            label.font = .systemFont(ofSize: 70, weight: .thin)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            #warning("dirty dancing, some UI cleanup will help")
            view.addSubview(cardView)
            cardView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
                label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2),
                label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 2)
            ])
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
            
            cardView.addSubview(handleView)
            handleView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
            handleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
            handleView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
            
            closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.6)
            cardView.transform = closedTransform
            
            panRecognizer.addTarget(self, action: #selector(panned))
            cardView.addGestureRecognizer(panRecognizer)
            
        }
    }
}

extension WordleKit.CardViewController {
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            var fraction = -recognizer.translation(in: cardView).y / closedTransform.ty
            if isOpen { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: cardView).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            if isOpen {
                if !shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if shouldClose && animator.isReversed { animator.isReversed.toggle() }
            } else {
                if shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if !shouldClose && animator.isReversed { animator.isReversed.toggle() }
            }
            let fractionRemaining = 1 - animator.fractionComplete
            
            let distanceRemaining = fractionRemaining * closedTransform.ty
            if distanceRemaining == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 30)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
            let preferredDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
            let durationFactor = CGFloat(preferredDuration / animator.duration)
            animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
            
        default: break
        }
    }
    
}

extension WordleKit.CardViewController {
    private func startAnimationIfNeeded() {
        if animator.isRunning { return }
        let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.cardView.transform = self.isOpen ? self.closedTransform : .identity
        }
        animator.addCompletion { position in
            if position == .end { self.isOpen.toggle() }
        }
        animator.startAnimation()
    }
}
    
    
    
