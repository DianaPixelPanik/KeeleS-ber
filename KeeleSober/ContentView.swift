import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: KeeleSoberViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.welcomeText)
                        .font(.title3)
                        .bold()

                    if viewModel.style == nil {
                        stylePicker
                    } else {
                        lessonFlow
                    }
                }
                .padding()
            }
            .navigationTitle("KeeleSõber")
        }
    }

    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Выбери стиль обучения:")
                .font(.headline)

            ForEach(Lehrstil.allCases) { style in
                Button {
                    viewModel.chooseStyle(style)
                } label: {
                    VStack(alignment: .leading) {
                        Text(style.rawValue)
                            .font(.body.bold())
                        Text(style.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }

            Button("Перейти на українську") {
                viewModel.switchToUkrainian()
            }
            .font(.footnote)
        }
    }

    private var lessonFlow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Материал из PDF: \(viewModel.sampleMaterialLine)")
                .font(.footnote)
                .foregroundStyle(.secondary)

            lessonStepBlock

            TextField("Введите ответ", text: $viewModel.inputText)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button("Оценить") {
                    viewModel.evaluate()
                }
                .buttonStyle(.borderedProminent)

                Button("Следующий шаг") {
                    viewModel.nextStep()
                }
                .buttonStyle(.bordered)
            }

            Text("XP: \(viewModel.xp)")
                .bold()
            if viewModel.streak >= 5 {
                Text("Отличная серия! 5 ответов подряд 🔥")
                    .foregroundStyle(.green)
            }

            if let feedback = viewModel.feedback {
                feedbackView(feedback)
            }
        }
    }

    @ViewBuilder
    private var lessonStepBlock: some View {
        switch viewModel.currentStep {
        case .introWord:
            Text("Введение слова: lugema / lugeda — читать.\nЛица: mina loen, sina loed...")
        case .recognition:
            Text("Распознавание: человек читает книгу. Что это по-эстонски?")
        case .miniDialogue:
            Text("Мини-диалог:\nA: Kas sa loed?\nB: Jah, ma loen raamatut.")
        case .speakOutLoud:
            Text("Скажи вслух: Ma loen iga päev eesti keeles.")
        case .feedback:
            Text("Оценка: отправь свою фразу, и я проверю.")
        case .spontaneousQuestion:
            Text("Вопрос: Mida sa tavaliselt õhtul loed?")
        }
    }

    private func feedbackView(_ feedback: EvaluationResult) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Сказал ученик: \(feedback.userSaid)")
            Text("Правильный вариант: \(feedback.correctVariant)")
            Text("Оценка: \(feedback.score)/10")
                .bold()
            Text(feedback.highlightedMistakes)
            Text(feedback.pronunciationTip)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.yellow.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
