//
//  PasswordValidationCheckView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 6/1/2569 BE.
//

import SwiftUI

struct ValidationRow: View {
    let title: String
    let passed: Bool
    let checkColor: Color
    let defaultColor: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(passed ? checkColor : defaultColor)
            Text(title)
                .font(.noto(14, weight: .medium))
                .foregroundColor(passed ? checkColor : defaultColor)
        }
    }
}

struct PasswordValidationCheckView: View {
    let password: String
    
    var body: some View {
        let checkColor: Color = Color.mainColor
        let defaultColor: Color = Color.placeholderColor
        
        VStack(alignment: .leading, spacing: 3) {
            // เรียกใช้ ValidationHelper ตรงๆ เลย
            ValidationRow(
                title: "อย่างน้อย 8 ตัวอักษร",
                passed: ValidationHelper.hasMinimumLength(password),
                checkColor: checkColor,
                defaultColor: defaultColor)
            ValidationRow(
                title: "มีตัวอักษรพิมพ์ใหญ่ อย่างน้อย 1 ตัว (A–Z)",
                passed: ValidationHelper.hasUppercase(password),
                checkColor: checkColor,
                defaultColor: defaultColor)
            ValidationRow(
                title: "มีตัวอักษรพิมพ์เล็ก อย่างน้อย 1 ตัว (a–z)",
                passed: ValidationHelper.hasLowercase(password),
                checkColor: checkColor,
                defaultColor: defaultColor)
            ValidationRow(
                title: "มีตัวเลข อย่างน้อย 1 ตัว (0–9)",
                passed: ValidationHelper.hasDigit(password),
                checkColor: checkColor,
                defaultColor: defaultColor)
            ValidationRow(
                title: "มีอักขระพิเศษ อย่างน้อย 1 ตัว (!@#$%&*_-)",
                passed: ValidationHelper.hasSpecialCharacter(password),
                checkColor: checkColor,
                defaultColor: defaultColor)
        }
        .frame(width: 345, alignment: .leading)
    }
}
