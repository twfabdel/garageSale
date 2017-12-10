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
    init(with sale: SaleModel) {
        self.sale = sale
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
        eventStore.requestAccess(to: .event) { (granted, err) in
            if !granted || err == nil {
                print("Error saving event")
            }
            let event = EKEvent(eventStore: eventStore)
            event.location = self.sale.address
            guard let start = self.sale.date?.getDate(withTime: self.sale.timeStart),
                let end = self.sale.date?.getDate(withTime: self.sale.timeEnd)
                else {
                    print("Error formatting start and end times")
                    return;
            }
            event.startDate = start
            event.endDate = end
            event.title = self.sale.title
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent)
                print("Added to calendar")
            } catch {
                print("Error saving event")
            }
        }
        activityDidFinish(true)
    }
}
