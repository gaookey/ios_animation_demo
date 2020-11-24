//
//  ViewController.swift
//  AnimatedCurveDemo
//
//  Created by swiftprimer on 2020/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var headerView: CurveRefreshHeaderView?
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200))
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "ID")
        return view
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        method()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    private func method() {
        
        let headerView = CurveRefreshHeaderView(view: tableView, withNavigationBar: false)
        self.headerView = headerView
        headerView.refreshingHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.headerView?.stopRefreshing()
            }
        }
        
        let footerView = CurveRefreshFooterView(view: tableView, withNavigationBar: false)
        footerView.refreshingHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                footerView.stopRefreshing()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView?.triggerPulling()
    }
}
