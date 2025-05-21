//
//  AppLogger.swift
//  StatisticsRik
//
//  Created by Глеб Капустин on 19.05.2025.
//

import OSLog

public final class AppLogger {
    public static let shared = AppLogger()

    private let logger: Logger

    private init() {
        self.logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "com.kapustin.StatisticsRik",
            category: "Application"
        )
    }

    public func logError(_ message: String) {
        logger.error("🔴 \(message)")
    }

    public func logInfo(_ message: String) {
        logger.info("ℹ️ \(message)")
    }

    public func logDebug(_ message: String) {
        logger.debug("🔍 \(message)")
    }

    public func logWarning(_ message: String) {
        logger.warning("⚠️ \(message)")
    }

    public func logSuccess(_ message: String) {
        logger.notice("✅ \(message)")
    }
}
