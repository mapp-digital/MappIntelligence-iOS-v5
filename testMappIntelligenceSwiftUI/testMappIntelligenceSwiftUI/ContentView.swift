//
//  ContentView.swift
//  testMappIntelligenceSwiftUI
//
//  Created by Stefan Stevanovic on 3.2.22..
//

import SwiftUI

struct ContentView: View {
    @State var username: String = ""
    @State var switchState: Bool = true
    @State private var selectedArray = [
            ["item1", "item2", "item3", "item4", "item5"],
            ["11", "22", "33", "44", "55"],
            ["1", "2", "3", "4", "5"]
        ]
    @State var parameters: MIFormParameters = MIFormParameters()
    var body: some View {
        TextField("Enter username...", text: $username).accessibility(label: Text("11")).accessibilityHint("hint_hintcina").tag(11)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
        TextField("Enter surname...", text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding().accessibilityLabel("22")
        Toggle("Show welcome message", isOn: $switchState).padding().accessibilityLabel("33")
        CustomPicker(dataArrays: $selectedArray).padding().accessibilityLabel("44")
        Button("Submit") {
            print("Submit button tapped")
            parameters.renameFields = [11:"Zivko"]
            parameters.changeFieldsValue = [22:"zivorad_bekrija"]
            parameters.fullContentSpecificFields = [22]
            MappIntelligence.shared()?.formTracking(parameters)
            
        }.padding()
        Button("Init") {
            print("Init button tapped")
            MappIntelligence.shared()?.initWithConfiguration([794940687426749], onTrackdomain: "http://tracker-int-01.webtrekk.net")
            MappIntelligence.shared()?.logLevel = .all
            MappIntelligence.shared()?.batchSupportEnabled = false
            MappIntelligence.shared()?.batchSupportSize = 150
            MappIntelligence.shared()?.requestInterval = 60
            MappIntelligence.shared()?.requestPerQueue = 300
            MappIntelligence.shared()?.shouldMigrate = true
            MappIntelligence.shared()?.sendAppVersionInEveryRequest = true
            MappIntelligence.shared()?.enableBackgroundSendout = true
            
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CustomPicker: UIViewRepresentable {
    @Binding var dataArrays : [[String]]

    //makeCoordinator()
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }

    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }

    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
        }

        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.dataArrays.count
        }

        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays[component].count
        }

        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width/3
        }

        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60
        }

        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: 60))

            let pickerLabel = UILabel(frame: view.bounds)

            pickerLabel.text = parent.dataArrays[component][row]

            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0

            view.addSubview(pickerLabel)

            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height * 0.1
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.black.cgColor

            return view
        }
    }
}
