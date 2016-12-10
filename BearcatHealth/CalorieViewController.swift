//
//  CalorieViewController.swift
//  BearcatHealth
//  Created by Pachipulusu,Venkatakotianilkumar on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
// This view controller class provides functionality for calories tab
import UIKit
import Parse
import Bolts
import Charts
class CalorieViewController: UIViewController, ChartViewDelegate {
    // MARK: - Properties
    // An outlet for bar chart view
    @IBOutlet weak var barChartView: BarChartView!
    // It holds types of meals to be displayed on X-axis of charts
    var mealType:[String] = ["Breakfast","Lunch","Dinner","Late night"]
    // It holds total intake breakfast,lunch,dinner and latenight
    var intake:[Int]!
    // An object for parseoperations class
    var parseOperations = ParseOperations()
    // An outlet for calories supposed to be consumed by the user as per his/her BMI
    @IBOutlet weak var calorieCountLBL: UILabel!
    // An outlet for calories consumed by the user
    @IBOutlet weak var calorieLBL: UILabel!
    // An implicitly unwrapped optional object for profile class
    var user:Profile!
    // This property allows us to share the appdelegate class
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // MARK: - Default methoods
    override func viewDidLoad() {
        intake = [appDelegate.breakfastIntakeCalories,appDelegate.lunchIntakeCalories,appDelegate.dinnerIntakeCalories,appDelegate.lateNightIntakeCalories]
        setChart(mealType,intake:intake)
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hotel-dining.jpg")!)
    }
    override func viewWillAppear(animated: Bool) {
        barChartView.delegate = self
        self.user = appDelegate.user
        intake = [appDelegate.breakfastIntakeCalories,appDelegate.lunchIntakeCalories,appDelegate.dinnerIntakeCalories,appDelegate.lateNightIntakeCalories]
        setChart(mealType,intake:intake)
        calorieCountLBL.text = String(Int(appDelegate.calorie)) + " cal"
        calorieLBL.text = String (appDelegate.breakfastIntakeCalories+appDelegate.lunchIntakeCalories+appDelegate.dinnerIntakeCalories+appDelegate.lateNightIntakeCalories) + " cal"
    }
    // MARK: - Bar charts
    // This method provides the data for bar charts and provides styles to the bars and background for the bar chart view
    func setChart(mealType: [String], intake: [Int]) {
        barChartView.noDataText = "No calories consumed"
        barChartView.descriptionText = ""
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<intake.count {
            let dataEntry = BarChartDataEntry(value: Double(intake[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Calories Consumed")
        let chartData = BarChartData(xVals: mealType, dataSet: chartDataSet)
        barChartView.data = chartData
        chartDataSet.colors = ChartColorTemplates.joyful()
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        let ll = ChartLimitLine(limit: Double(appDelegate.calorie/4), label: "Supposed calorie intake limit")
        barChartView.rightAxis.addLimitLine(ll)
    }
    // This method resets data of barcharts when user selects clear intake button
    @IBAction func clearIntakeBTN(sender: UIButton) {
        appDelegate.breakfastIntakeCalories = 0
        appDelegate.lunchIntakeCalories = 0
        appDelegate.dinnerIntakeCalories = 0
        appDelegate.lateNightIntakeCalories = 0
        parseOperations.clearIntake(appDelegate.userName)
        intake = [appDelegate.breakfastIntakeCalories,appDelegate.lunchIntakeCalories,appDelegate.dinnerIntakeCalories,appDelegate.lateNightIntakeCalories]
        calorieLBL.text = String (appDelegate.breakfastIntakeCalories+appDelegate.lunchIntakeCalories+appDelegate.dinnerIntakeCalories+appDelegate.lateNightIntakeCalories) + " cal"
        BreakfastTableViewController.breakfastItems = []
        LunchTableViewController.lunchItems = []
        DinnerTableViewController.dinnerItems = []
        LateNightTableViewController.lateNightItems = []
        MenuViewController.breakfastIntakeCalories = []
        MenuViewController.lunchIntakeCalories = []
        MenuViewController.dinnerIntakeCalories = []
        MenuViewController.lateNightIntakeCalories = []
        setChart(mealType,intake:intake)
    }
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
    }
}
