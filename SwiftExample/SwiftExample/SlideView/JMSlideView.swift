//
//  JMSlideView.swift
//  SwiftExample
//
//  Created by jianmei on 2023/3/31.
//

import UIKit

class JMSlideView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
           
    private var bottomH : CGFloat = .zero //下滑后距离顶部的距离
    private var stop_y : CGFloat = .zero  //tableView滑动停止的位置
    private var smallHeight : CGFloat = .zero  //原始高度
    private var bigHeight : CGFloat = .zero   //撑大的时候高度
    public var topH : CGFloat = .zero { //上滑后距离顶部的距离
        didSet {
            self.bigHeight = CGRectGetMaxY(self.frame) - topH;
        }
        
    }
    
    lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableViewCell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        return tableView;
    }()
    
    lazy var lazyGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        gesture.delegate = self
        return gesture
    }()
    
    // MARK: life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.smallHeight = self.height
        self.bottomH = self.y
                        
        self.addGestureRecognizer(self.lazyGesture)
        self.addSubview(self.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Fun
    
    func goTop() {
        UIView.animate(withDuration: 0.5) {
            self.y = self.topH
            self.height = self.bigHeight
            self.tableView.height = self.bigHeight
        } completion: { finished in
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    func goBack() {
        UIView.animate(withDuration: 0.5) {
            self.y = self.bottomH;
            self.height = self.smallHeight;
            self.tableView.height = self.smallHeight;
        } completion: { finished in
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        // 获取视图偏移量
        let point = pan.translation(in: self)
        
        // stop_y是tableview的偏移量，当tableview的偏移量大于0时则不去处理视图滑动的事件
        if (self.stop_y>0) {
            // 将视频偏移量重置为0
            pan.setTranslation(CGPointMake(0, 0), in: self)
            return;
        }
        
        // self.y是视图距离顶部的距离
        self.y += point.y;
        if (self.y < self.topH) {
            self.y = self.topH;
            self.tableView.isScrollEnabled = true
        } else {
//            self.tableView.isScrollEnabled = false
            if (point.y > 0 && self.height > self.smallHeight) {
                let height = self.height - point.y;
                self.height = max(height, self.smallHeight);
                self.tableView.height = self.height;
            }
        }
        
        // self.bottomH是视图在底部时距离顶部的距离
        if (self.y > self.bottomH) {
            self.y = self.bottomH;
        } else {
            if (point.y < 0 && self.height < self.bigHeight) {
                self.tableView.isScrollEnabled = false
                let height = self.height - point.y;
                self.height = min(height, self.bigHeight);
                self.tableView.height = self.height;
            }
        }
        
        // 在滑动手势结束时判断滑动视图距离顶部的距离是否超过了屏幕的一半，如果超过了一半就往下滑到底部
        // 如果小于一半就往上滑到顶部
        if (pan.state == UIGestureRecognizer.State.ended || pan.state == UIGestureRecognizer.State.cancelled) {
            
            // 滑动速度
            let velocity = pan.velocity(in: self);
            let speed = 350.0;
            if (velocity.y < -speed) {
                goTop()
                pan.setTranslation(CGPointMake(0, 0), in: self)
                return;
            }else if (velocity.y > speed){
                goBack()
                pan.setTranslation(CGPointMake(0, 0), in: self)
                return;
            }
            
            if (self.y > kScreenH / 2) {
                goBack()
            }else{
                goTop()
            }
        }
        pan.setTranslation(CGPointMake(0, 0), in: self)
    }
    
        
    // MARK: - UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "第" + "\(indexPath.row+1)" + "行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.stop_y = scrollView.contentOffset.y
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }    

}

