//
//  AddToCalendarActivity.swift
//  GarageSale
//
//  Created by Tarek Abdelghany on 12/10/17.
//  Copyright © 2017 Tarek Abdelghany. All rights reserved.
//

import EventKit
import UIKit

/* General skeleton, i.e. how to make custom UIActivity, adapted
 * from https://gist.github.com/shu223/2e885d5acdb438667fdd4e540a090733
 */
class AddToCalendarActivity: UIActivity {
    
    var sale: SaleModel!
    var completionHandler: ((String)->Void)?
    init(with sale: SaleModel, completion: ((String)->Void)?) {
        self.sale = sale
        self.completionHandler = completion
    }
    
    override var activityTitle: String? {
        return "Add To Calendar"
    }
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "calendar_add")
    }
    override var activityType: UIActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    override class var activityCategory: UIActivityCategory {
        return .action
    }
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func perform() {
        let eventStore = EKEventStore()
        weak var weakSelf = self
        eventStore.requestAccess(to: .event) { (granted, error) in
            var message = ""
            if !granted{
                message = "Permission not granted to access calendar"
            } else if let err = error {
                message = "Error creating event: \(err.localizedDescription)"
            } else {
                let event = EKEvent(eventStore: eventStore)
                event.location = self.sale.address
                if let start = self.sale.date?.getDate(withTime: self.sale.timeStart),
                    let end = self.sale.date?.getDate(withTime: self.sale.timeEnd) {
                    event.startDate = start
                    event.endDate = end
                    event.title = self.sale.title
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    
                    try? eventStore.save(event, span: .thisEvent)
                    message = "Added garage sale to your calendar!"
                } else {
                    message = "Error parsing garage sale"
                }
            }
            weakSelf?.completionHandler?(message)
        }
        activityDidFinish(true)
    }
}
