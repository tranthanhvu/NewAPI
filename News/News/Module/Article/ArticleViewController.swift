//
//  ArticleViewController.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ArticleViewController: UIViewController, ViewBindableProtocol {

    // MARK: - UI
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    private var imagePaddingTopValue: CGFloat = 0
    
    // MARK: - Rx + Data
    let disposeBag = DisposeBag()
    var viewModel: ArticleViewModel!
    
    private var imageRectPath: UIBezierPath {
        var newFrame = textView.convert(imageView.frame, from: view)
        newFrame.origin.x = 0
        newFrame.size.width = self.view.bounds.width
        
        newFrame = newFrame.inset(by: UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
        
        let path = UIBezierPath(rect: newFrame)
        return path
    }
    
    override func loadView() {
        super.loadView()
        
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if imageView.isHidden == false {
            textView.textContainer.exclusionPaths = [imageRectPath]
            textView.textContainer.layoutManager?.ensureLayout(for: textView.textContainer)
        }
    }
    
    private func setupUI() {
        self.imageView.isHidden = true
        
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowRadius = 3
        self.imageView.layer.shadowOpacity = 0.3
        self.imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        detailButton.layer.cornerRadius = detailButton.frame.height * 0.5
        
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 70, right: 10)
    }
    
    private func bindUI() {
        textView.rx.contentOffset
            .map({ $0.y })
            .bind(onNext: { [weak self] y in
                guard let self = self else { return }
                
                self.imageTopConstraint.constant = -y + self.imagePaddingTopValue
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let input = ArticleViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asDriver().mapToVoid(),
            tapDetail: detailButton.rx.tap.asDriver().mapToVoid()
        )
        
        let output = viewModel.transform(input)
        
        output.data
            .drive(onNext: { [weak self] article in
                self?.updateUI(article: article)
            })
            .disposed(by: self.disposeBag)
        
        output.openWebView
            .drive()
            .disposed(by: self.disposeBag)
    }
    
    private func updateUI(article: Article) {
        let title = NSAttributedString(string: article.title, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ])
        
//        let longContent = (0...30).map({ _ in article.content }).joined(separator: "\n")
        
        let content = article.content.isEmpty ? article.description : article.content
        
        let desc = NSAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ])
        
        let leftParagraphStyle = NSMutableParagraphStyle()
        leftParagraphStyle.alignment = .right
        
        let sign = NSAttributedString(string: article.author + "\n" + article.publishedAt.toString, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.paragraphStyle: leftParagraphStyle
        ])
        
        let br = NSAttributedString(string: "\n\n\n")
        
        let attString = NSMutableAttributedString()
        [title, br, desc, br, sign].forEach { (item) in
            attString.append(item)
        }
        
        self.textView.attributedText = attString
        
        if let imageUrl = URL(string: article.urlToImage) {
            self.imageView.isHidden = false
            self.imageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            self.imageView.isHidden = true
        }
        
        
        if let titleRect = textRect(article.title) {
            let newRect = view.convert(titleRect, from: self.textView)
            imagePaddingTopValue = newRect.maxY
            imageTopConstraint.constant = newRect.maxY
            self.view.layoutIfNeeded()
        }
    }
    
    private func textRect(_ text: String) -> CGRect? {
        let range = NSMakeRange(0, text.count)
        if let start = self.textView.position(from: self.textView.beginningOfDocument, offset: range.location),
           let end = self.textView.position(from: start, offset: range.length),
           let textRange = self.textView.textRange(from: start, to: end) {
            
            self.textView.layoutManager.ensureLayout(for: self.textView.textContainer)
            
            var rect = self.textView.firstRect(for: textRange)
            
            let list = self.textView.selectionRects(for: textRange)
            list.forEach { (textRect) in
                rect = rect.union(textRect.rect)
            }
            
            rect.origin.y += self.textView.contentInset.top + self.textView.textContainerInset.top
            
            return rect
        }
        
        return nil
    }
}
