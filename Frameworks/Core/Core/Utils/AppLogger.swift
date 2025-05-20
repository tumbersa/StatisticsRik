//
//  AppLogger.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import OSLog

final class AppLogger {
    static let shared = AppLogger()

    private let logger: Logger

    private init() {
        self.logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "com.kapustin.StatisticsRik",
            category: "Application"
        )
    }

    func logError(_ message: String) {
        logger.error("🔴 \(message)")
    }

    func logInfo(_ message: String) {
        logger.info("ℹ️ \(message)")
    }

    func logDebug(_ message: String) {
        logger.debug("🔍 \(message)")
    }

    func logWarning(_ message: String) {
        logger.warning("⚠️ \(message)")
    }

    func logSuccess(_ message: String) {
        logger.notice("✅ \(message)")
    }
}
