import Foundation

enum Lehrstil: String, CaseIterable, Identifiable {
    case friendly = "Friendly Teacher"
    case strict = "Strict Teacher"
    case savage = "Savage Funny Coach"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .friendly:
            return "Теплый и поддерживающий"
        case .strict:
            return "Строгий и четкий"
        case .savage:
            return "Дерзкий тренер: шутим над ошибками, но не над учеником"
        }
    }
}

enum StudyLanguage {
    case russian
    case ukrainian
}

enum LessonStep: String, CaseIterable {
    case introWord
    case recognition
    case miniDialogue
    case speakOutLoud
    case feedback
    case spontaneousQuestion
}

struct VerbCard {
    let maForm: String
    let daForm: String
    let translation: String
    let persons: [String]
}

struct NounCard {
    let word: String
    let translation: String
    let example: String
}

enum VocabularyCard {
    case verb(VerbCard)
    case noun(NounCard)
}

struct EvaluationResult {
    let userSaid: String
    let correctVariant: String
    let score: Int
    let highlightedMistakes: String
    let pronunciationTip: String
}
