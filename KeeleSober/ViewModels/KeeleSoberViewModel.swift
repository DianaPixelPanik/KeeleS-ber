import Foundation

final class KeeleSoberViewModel: ObservableObject {
    @Published var style: Lehrstil?
    @Published var language: StudyLanguage = .russian
    @Published var currentStep: LessonStep = .introWord
    @Published var inputText: String = ""
    @Published var xp: Int = 0
    @Published var streak: Int = 0
    @Published var feedback: EvaluationResult?

    private let pdfService = PDFMaterialService()

    let currentCard: VocabularyCard = .verb(
        VerbCard(
            maForm: "lugema",
            daForm: "lugeda",
            translation: "читать",
            persons: ["mina loen", "sina loed", "tema loeb", "meie loeme", "teie loete", "nemad loevad"]
        )
    )

    init() {
        pdfService.loadBundledMaterial()
    }

    var welcomeText: String {
        "Tere! Я твой партнер по практике эстонского — KeeleSõber. Давай начнем!"
    }

    var sampleMaterialLine: String {
        pdfService.sampleLine() ?? "Добавьте PDF в Bundle приложения, чтобы упражнения брались из учебных материалов."
    }

    func chooseStyle(_ value: Lehrstil) {
        style = value
    }

    func switchToUkrainian() {
        language = .ukrainian
    }

    func nextStep() {
        guard let index = LessonStep.allCases.firstIndex(of: currentStep) else { return }
        let nextIndex = LessonStep.allCases.index(after: index)
        currentStep = nextIndex < LessonStep.allCases.endIndex ? LessonStep.allCases[nextIndex] : .introWord
    }

    func evaluate() {
        let normalized = inputText.lowercased()
        let correct = "ma loen raamatut"
        let isPerfect = normalized == correct
        let score = isPerfect ? 10 : 7

        if isPerfect {
            xp += 20
            streak += 1
        } else {
            xp += 10
            streak = 0
        }

        feedback = EvaluationResult(
            userSaid: inputText,
            correctVariant: correct,
            score: score,
            highlightedMistakes: isPerfect ? "Ошибок нет." : "Я **читаю** книгу → Ma **loen** raamatut.",
            pronunciationTip: "Подсказка: звук õ произносится глубже, чем русское 'ы'. Попробуй ещё раз."
        )
    }
}
