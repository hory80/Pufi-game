import SwiftUI

/// Poarta pentru părinți (obligatorie la categoria Kids înainte de cumpărături și setări).
/// O înmulțire scrisă în cuvinte: un copil de 6 ani nu o poate rezolva, un adult da.
struct ParentalGateView: View {
    let language: String
    let onResult: (Bool) -> Void

    @State private var a = Int.random(in: 3...9)
    @State private var b = Int.random(in: 3...9)
    @State private var options: [Int] = []

    private static let numbers: [String: [String]] = [
        "ro": ["", "unu", "doi", "trei", "patru", "cinci", "șase", "șapte", "opt", "nouă"],
        "de": ["", "eins", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun"],
        "en": ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    ]
    private static let texts: [String: (String, String, String)] = [
        "ro": ("Pentru părinți", "Cât face %@ ori %@?", "Anulează"),
        "de": ("Für Eltern", "Wie viel ist %@ mal %@?", "Abbrechen"),
        "en": ("For parents", "What is %@ times %@?", "Cancel")
    ]

    var body: some View {
        let lang = Self.texts[language] != nil ? language : "en"
        let t = Self.texts[lang]!
        let n = Self.numbers[lang]!
        VStack(spacing: 24) {
            Text("🔒 " + t.0).font(.system(size: 30, weight: .heavy, design: .rounded))
            Text(String(format: t.1, n[a], n[b])).font(.system(size: 26, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(options, id: \.self) { v in
                    Button("\(v)") { onResult(v == a * b) }
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, minHeight: 64)
                        .background(Color(red: 1, green: 0.95, blue: 0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            Button(t.2) { onResult(false) }.font(.title3)
        }
        .padding(32)
        .onAppear {
            var set = Set([a * b])
            while set.count < 4 { set.insert(a * b + Int.random(in: -12...12)) }
            options = set.filter { $0 > 0 }.shuffled()
            if !options.contains(a * b) { options[0] = a * b; options.shuffle() }
        }
    }
}
