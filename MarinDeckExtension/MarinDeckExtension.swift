//
//  MarinDeckExtension.swift
//  MarinDeckExtension
//
//  Created by craptone on 2021/04/15.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct TrendView: View {
    @Binding var title: String
    @Binding var ranking: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30)
                Text(ranking)
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
                
            Text(title)
        }
    }
}

struct MarinDeckExtensionEntryView : View {
    var entry: Provider.Entry
    
    @State var title3rd: String = "3"

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.12, blue: 0.16)
                 .edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 30, height: 30)
                            Text("1")
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
                        }
                            
                        Text("からあげクン誕生日おめでとう")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 30, height: 30)
                            Text("2")
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                            
                        Text("あんスタSSスタンプラリー")
                            .foregroundColor(.white)
                    }
                    
                    TrendView(title: $title3rd, ranking: $title3rd)

                }
                .padding()
            }
            .padding(10)
        }
    }
    
}

@main
struct MarinDeckExtension: Widget {
    let kind: String = "MarinDeckExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MarinDeckExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Twitter trend")
        .description("Twitterのトレンドが表示されます。")
    }
}

struct MarinDeckExtension_Previews: PreviewProvider {
    static var previews: some View {
        MarinDeckExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
