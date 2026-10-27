import Foundation
import PDFKit

final class PDFMaterialService {
    private(set) var loadedMaterial: [String] = []

    func loadBundledMaterial() {
        let pdfURLs = Bundle.main.urls(forResourcesWithExtension: "pdf", subdirectory: nil) ?? []

        loadedMaterial = pdfURLs
            .compactMap(Self.extractText(from:))
            .flatMap { $0.components(separatedBy: .newlines) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    func sampleLine() -> String? {
        loadedMaterial.randomElement()
    }

    private static func extractText(from url: URL) -> String? {
        guard let document = PDFDocument(url: url) else {
            return nil
        }

        var text = ""
        for pageIndex in 0..<document.pageCount {
            text += document.page(at: pageIndex)?.string ?? ""
            text += "\n"
        }
        return text
    }
}
