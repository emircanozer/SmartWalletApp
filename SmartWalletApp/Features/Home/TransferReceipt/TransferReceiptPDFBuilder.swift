import UIKit

//dekont
enum TransferReceiptPDFBuilder {
    static func exportURL(for data: TransferReceiptViewData) throws -> URL {
        let sanitizedReference = data.referenceNumberText
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: " ", with: "-")
        let fileName = "Dekont-\(sanitizedReference.isEmpty ? UUID().uuidString : sanitizedReference).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let pageBounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        // pdf oluşturucu 
        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds)
        try renderer.writePDF(to: url) { context in
            context.beginPage()
            UIColor.white.setFill()
            context.fill(pageBounds)

            let margin: CGFloat = 40
            let contentWidth = pageBounds.width - (margin * 2)
            var y: CGFloat = 44

            func draw(_ text: String, font: UIFont, color: UIColor, frame: CGRect, alignment: NSTextAlignment = .left) {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = alignment
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraph
                ]
                text.draw(in: frame, withAttributes: attributes)
            }

            func drawAttributed(_ text: NSAttributedString, frame: CGRect) {
                text.draw(in: frame)
            }

            let headerTop = y

            if let logo = UIImage(named: "logo") {
                let logoFrame = CGRect(x: margin, y: headerTop, width: 64, height: 64)
                context.cgContext.saveGState()
                let clipPath = UIBezierPath(roundedRect: logoFrame, cornerRadius: 14)
                clipPath.addClip()
                logo.draw(in: logoFrame)
                context.cgContext.restoreGState()
            }

            let appName = NSMutableAttributedString(
                string: "SmartWallet AI",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                    .foregroundColor: UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
                ]
            )
            let aiRange = NSRange(location: "SmartWallet ".count, length: 2)
            appName.addAttributes([
                .foregroundColor: UIColor(red: 1.0, green: 0.76, blue: 0.06, alpha: 1.0)
            ], range: aiRange)
            drawAttributed(appName, frame: CGRect(x: margin + 78, y: headerTop + 13, width: contentWidth - 78, height: 34))
            y = headerTop + 86

            draw("İşlem Detayı", font: .systemFont(ofSize: 26, weight: .bold), color: UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0), frame: CGRect(x: margin, y: y, width: contentWidth, height: 30), alignment: .center)
            y += 34
            draw("İşlem başarıyla gerçekleşti", font: .systemFont(ofSize: 14, weight: .semibold), color: UIColor(red: 0.66, green: 0.68, blue: 0.74, alpha: 1.0), frame: CGRect(x: margin, y: y, width: contentWidth, height: 18), alignment: .center)
            y += 34

            let cardFrame = CGRect(x: margin, y: y, width: contentWidth, height: 360)
            let cardPath = UIBezierPath(roundedRect: cardFrame, cornerRadius: 28)
            UIColor.white.setFill()
            cardPath.fill()
            context.cgContext.setShadow(offset: CGSize(width: 0, height: 8), blur: 24, color: UIColor.black.withAlphaComponent(0.06).cgColor)
            UIColor.clear.setFill()
            cardPath.fill()
            context.cgContext.setShadow(offset: .zero, blur: 0, color: nil)

            func drawRow(title: String, value: String, top: CGFloat, isLarge: Bool = false, accent: Bool = false) {
                let titleY = cardFrame.minY + top
                let titleColor = UIColor(red: 0.69, green: 0.71, blue: 0.76, alpha: 1.0)
                let valueColor = accent ? UIColor(red: 0.58, green: 0.49, blue: 0.13, alpha: 1.0) : UIColor(red: 0.16, green: 0.17, blue: 0.23, alpha: 1.0)
                draw(title.uppercased(), font: .systemFont(ofSize: 11, weight: .bold), color: titleColor, frame: CGRect(x: cardFrame.minX + 20, y: titleY, width: 120, height: 14))
                draw(value, font: isLarge ? .systemFont(ofSize: 24, weight: .bold) : .systemFont(ofSize: 16, weight: .bold), color: valueColor, frame: CGRect(x: cardFrame.minX + 160, y: titleY - (isLarge ? 8 : 0), width: cardFrame.width - 180, height: isLarge ? 30 : 20), alignment: .right)
            }

            func divider(_ top: CGFloat) {
                let rect = CGRect(x: cardFrame.minX + 20, y: cardFrame.minY + top, width: cardFrame.width - 40, height: 1)
                UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0).setFill()
                context.fill(rect)
            }

            drawRow(title: "Gönderen", value: data.senderNameText, top: 22)
            divider(48)
            drawRow(title: "Alıcı", value: data.receiverNameText, top: 62)
            divider(88)
            draw("IBAN", font: .systemFont(ofSize: 11, weight: .bold), color: UIColor(red: 0.69, green: 0.71, blue: 0.76, alpha: 1.0), frame: CGRect(x: cardFrame.minX + 20, y: cardFrame.minY + 102, width: 120, height: 14))
            draw(data.ibanText, font: .monospacedSystemFont(ofSize: 14, weight: .medium), color: UIColor(red: 0.45, green: 0.47, blue: 0.54, alpha: 1.0), frame: CGRect(x: cardFrame.minX + 20, y: cardFrame.minY + 124, width: cardFrame.width - 40, height: 18))
            divider(154)
            drawRow(title: "Tutar", value: data.amountText, top: 170, isLarge: true)
            divider(210)
            drawRow(title: "İşlem Tarihi", value: data.transactionDateText, top: 226)
            divider(252)
            drawRow(title: "Referans No", value: data.referenceNumberText, top: 266, accent: true)
            divider(292)
            drawRow(title: "İşlem Türü", value: data.categoryTitleText, top: 306)

            let noteFrame = CGRect(x: cardFrame.minX + 20, y: cardFrame.minY + 332, width: cardFrame.width - 40, height: 70)
            let notePath = UIBezierPath(roundedRect: noteFrame, cornerRadius: 18)
            UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0).setFill()
            notePath.fill()
            UIColor(red: 0.63, green: 0.54, blue: 0.11, alpha: 0.9).setFill()
            context.fill(CGRect(x: noteFrame.minX, y: noteFrame.minY, width: 3, height: noteFrame.height))
            draw("İŞLEM NOTU", font: .systemFont(ofSize: 11, weight: .bold), color: UIColor(red: 0.69, green: 0.71, blue: 0.76, alpha: 1.0), frame: CGRect(x: noteFrame.minX + 14, y: noteFrame.minY + 10, width: noteFrame.width - 28, height: 14))
            draw(data.noteText, font: .systemFont(ofSize: 14, weight: .medium), color: UIColor(red: 0.24, green: 0.25, blue: 0.29, alpha: 1.0), frame: CGRect(x: noteFrame.minX + 14, y: noteFrame.minY + 30, width: noteFrame.width - 28, height: 28))
        }

        return url
    }
}
