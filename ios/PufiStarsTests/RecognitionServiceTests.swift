import XCTest
import AVFoundation
import Speech
@testable import PufiStars

final class RecognitionServiceTests: XCTestCase {
    func testPermissionReasonsKeepSpeechAndMicrophoneSeparate() {
        XCTAssertEqual(RecognitionService.permissionFailure(speech: "denied", mic: "granted")?.reason, "speech-denied")
        XCTAssertEqual(RecognitionService.permissionFailure(speech: "restricted", mic: "denied")?.reason, "speech-restricted")
        XCTAssertEqual(RecognitionService.permissionFailure(speech: "notDetermined", mic: "undetermined")?.reason, "speech-notDetermined")
        XCTAssertEqual(RecognitionService.permissionFailure(speech: "authorized", mic: "denied")?.reason, "mic-denied")
        XCTAssertNil(RecognitionService.permissionFailure(speech: "authorized", mic: "granted"))
        XCTAssertEqual(RecognitionService.speechPermission(.notDetermined), "notDetermined")
    }

    func testZeroInputFormatIsRejectedBeforeInstallingTap() throws {
        XCTAssertFalse(RecognitionService.validFormat(AVAudioFormat()))
        let valid = try XCTUnwrap(AVAudioFormat(standardFormatWithSampleRate: 48000, channels: 1))
        XCTAssertTrue(RecognitionService.validFormat(valid))
    }

    func testNetworkRetryOnlyForImmediateOnDeviceFailureWithoutTranscript() {
        XCTAssertTrue(RecognitionService.shouldRetryOnNetwork(onDevice: true, hasText: false, elapsed: 0.2))
        XCTAssertFalse(RecognitionService.shouldRetryOnNetwork(onDevice: false, hasText: false, elapsed: 0.2))
        XCTAssertFalse(RecognitionService.shouldRetryOnNetwork(onDevice: true, hasText: true, elapsed: 0.2))
        XCTAssertFalse(RecognitionService.shouldRetryOnNetwork(onDevice: true, hasText: false, elapsed: 10))
    }
}
