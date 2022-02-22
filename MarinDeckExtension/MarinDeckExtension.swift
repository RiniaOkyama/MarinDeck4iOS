//
//  MarinDeckExtension.swift
//  MarinDeckExtension
//
//  Created by Rinia on 2021/04/15.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> Void) {
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
            //            ZStack {
            //                Circle()
            //                    .fill(Color.clear)
            //                    .frame(width: 30, height: 30)
            //                Text(ranking)
            //                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            //            }

            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)

        }
    }
}

struct MarinDeckExtensionEntryView: View {
    var entry: Provider.Entry

    @State var title1st: String = "#ゲットしよう15種のお菓子"
    @State var title2nd: String = "#本当に人間ですか"
    @State var title3rd: String = "御園座初日"

    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.12, blue: 0.16)
                .edgesIgnoringSafeArea(.all)

            HStack {
                VStack(alignment: .leading, spacing: 15.0) {
                    TrendView(title: $title1st, ranking: $title3rd)
                    TrendView(title: $title2nd, ranking: $title3rd)
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
