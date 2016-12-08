//
//  CalorieViewController.swift
//  BearcatHealth
//  Created by Gayam,Prathibha on 10/6/16.
//  Copyright © 2016 Gayam,Prathibha. All rights reserved.
//
import UIKit
import Parse
import Bolts
import Charts
class CalorieViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var barChartView: BarChartView!
    var mealType:[String] = ["Breakfast","Lunch","Dinner","Late night"]
    var intake:[Int]!
    var parseOperations = ParseOperations()
    var frameWidth = 0
    var onePart = 0.0
    @IBOutlet weak var calorieCountLBL: UILabel!
    @IBOutlet weak var calorieLBL: UILabel!
    var user:Profile!
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
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
