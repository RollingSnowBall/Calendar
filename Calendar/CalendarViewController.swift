//
//  ViewController.swift
//  Calendar
//
//  Created by JUNO on 2022/08/06.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    private var calendarHeight: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    
    private lazy var calendarTitle: UILabel = {
        let label = UILabel()
        label.text = "방문 기록"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        
        return label
    }()
    
    private lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        
        view.appearance.headerTitleColor = .black
        
        view.appearance.titleWeekendColor = .red
        view.appearance.titleDefaultColor = .label
        
        view.placeholderType = .none
        //view.appearance.titlePlaceholderColor = .systemBackground
        
        view.appearance.headerMinimumDissolvedAlpha = 0
        
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    private lazy var resizeButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "chevron.up")
        
        button.setImage(chevronImage, for: .normal)
        button.addTarget(self , action: #selector(resize), for: .touchDown)
        
        return button
    }()
    
    private lazy var todayButton: UIButton = {
        let button = UIButton()

        button.configuration = .tinted()
        button.configuration?.title = " 오늘 "
        
        button.addTarget(self, action: #selector(setToday), for: .touchDown)

        return button
    }()
    
    private lazy var addEventButton: UIButton = {
        let button = UIButton()
        
        button.configuration = .tinted()
        button.configuration?.title = "새로운 일정"
        
        return button
    }()
    
    private lazy var scheduleTableView: UITableView = {
        let tableview = UITableView()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    
    @objc func resize(){
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            resizeButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            calendar.setScope(.month, animated: true)
            resizeButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
    }
    
    @objc func setToday(){
        calendar.select(calendar.today)
    }
}

private extension CalendarViewController {
    
    func setupLayout(){
        
        calendarHeight = (view.bounds.height) / 3
        
        [ calendarTitle, todayButton, calendar, resizeButton, addEventButton
         ,scheduleTableView ].forEach {
            view.addSubview($0)
        }
        
        calendarTitle.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        
        todayButton.snp.makeConstraints{
            $0.bottom.equalTo(calendarTitle.snp.bottom)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        calendar.snp.makeConstraints{
            $0.top.equalTo(calendarTitle.snp.bottom).offset(10)
            $0.width.equalTo(view.bounds.width - 20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(calendarHeight)
        }
        
        resizeButton.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        addEventButton.snp.makeConstraints{
            $0.centerY.equalTo(resizeButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        scheduleTableView.snp.makeConstraints{
            $0.top.equalTo(addEventButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
}

extension CalendarViewController:
    FSCalendarDataSource, FSCalendarDelegate,
    UITableViewDataSource, UITableViewDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // monthPosition.rawValue
        // 0 이면 저번 달
        // 1 이면 이번 달
        // 2 이면 다음 달
        if monthPosition.rawValue == 0 {
            calendar.setCurrentPage(date, animated: true)
        }
        else if monthPosition.rawValue == 2 {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "1"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "8월"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//            // move up
//            calendar.setScope(.week, animated: true)
//            resizeButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            // move down
//            calendar.setScope(.month, animated: true)
//            resizeButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
//        }
    }
}

