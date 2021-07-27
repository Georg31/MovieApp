//
//  CustomFilterView.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/14/21.
//

import UIKit

protocol FilterMovies {
    func filter(by: Type)
}

class CustomFilterView: UIView{

    var delegate: FilterMovies?
    private var tableView: UITableView!
    private var filterView: UIView!
    private var fadeView: UIView!
    var datasource = [Type]()
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupView(){
        self.backgroundColor = .none
        filterView = UIView(frame: CGRect(x: self.frame.width / 3, y: self.frame.minY, width: self.frame.width/3 + self.frame.width, height: self.frame.height))
        //filterView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fadeView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: self.filterView.frame.minX, height: self.frame.height))
        fadeView.backgroundColor = .black
        fadeView.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(HideFilter(_:)))
        fadeView.addGestureRecognizer(tap)
        self.addSubview(filterView)
        self.addSubview(fadeView)
        self.frame.origin.x = self.frame.maxX
        
        tableView = UITableView(frame: filterView.bounds)
        tableView.separatorStyle = .none
        filterView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.filterCell, bundle: nil), forCellReuseIdentifier: Constants.filterCell)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    func showFilter(){
        UIView.animate(withDuration: 0.7) {
            self.frame.origin.x = 0
            self.parentViewController?.navigationController?.isNavigationBarHidden = true
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.2) {
                fadeView.alpha = 0.5
            }
        }
        
    }
    
    @objc func HideFilter(_ sender: UITapGestureRecognizer? = nil){
        self.fadeView.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            self.frame.origin.x = self.frame.maxX
            self.parentViewController?.navigationController?.isNavigationBarHidden = false
        }
    }
    
}

extension CustomFilterView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filterCell, for: indexPath) as! FilterCell
        cell.typeLabel?.text = self.datasource[indexPath.row].StringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.filter(by: self.datasource[indexPath.row])
        HideFilter()
    }
    
}

