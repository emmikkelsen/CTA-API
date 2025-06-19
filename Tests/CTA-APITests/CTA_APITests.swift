import Foundation
import Testing

@testable import CTA_API

// MARK: - Test Protocols

/// Protocol that defines how to convert an API model to a resource
public protocol APIModel {
    associatedtype Resource
    func toResource() -> Resource
}

// MARK: - Mock Responses
private struct MockResponse: Codable, Equatable, EmptyInit, Sendable {
    let message: String
    let data: String

    init() {
        self.message = ""
        self.data = ""
    }

    init(message: String, data: String) {
        self.message = message
        self.data = data
    }

    static func == (lhs: MockResponse, rhs: MockResponse) -> Bool {
        return lhs.message == rhs.message && lhs.data == rhs.data
    }

    static func initEmpty() -> MockResponse {
        MockResponse()
    }

    func toData() -> Data {
        try! JSONEncoder().encode(self)
    }
}

private struct MockError: Error, Equatable {
    let description: String
}

// MARK: - Test Models
private struct MockAPIModel: APIModel, Codable, EmptyInit {
    typealias Resource = MockResponse

    let mockResponse: MockResponse

    func toResource() -> MockResponse {
        return mockResponse
    }

    static func initEmpty() -> MockAPIModel {
        MockAPIModel(mockResponse: MockResponse(message: "", data: ""))
    }

    init(mockResponse: MockResponse) {
        self.mockResponse = mockResponse
    }

    enum CodingKeys: String, CodingKey {
        case mockResponse
    }
}

// MARK: - Mock Caller Implementations
extension CTAApiTests {
    // A mock caller that always returns the given data and response
    fileprivate static func mockCaller(returning data: Data, response: HTTPURLResponse) -> @Sendable
    (URL) async throws -> (Data, URLResponse) {
        return { _ in (data, response) }
    }

    // A mock caller that always throws the given error
    fileprivate static func failingCaller(error: Error) -> @Sendable (URL) async throws -> (
        Data, URLResponse
    ) {
        return { _ in throw error }
    }

    // Helper to create a successful HTTP response
    fileprivate static func successResponse() -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
    }

    // Helper to create an error HTTP response
    fileprivate static func errorResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
    }
}

@MainActor
@Suite("CTA API Tests")
struct CTAApiTests {
    private var api: CTAAPI!
    private let testBusKey = "test_bus_key"
    private let testTrainKey = "test_train_key"

    @Test("API initialization with keys")
    func testAPIInitialization() {
        let api = CTAAPI(busKey: testBusKey, trainKey: testTrainKey)
        #expect(api.busKey == testBusKey)
        #expect(api.trainKey == testTrainKey)
    }

    // MARK: - Test Helpers

    private struct TestDecodableResource: APIResource, Sendable {
        typealias Resource = MockResponse
        typealias APIModelType = MockAPIModel

        let methodPath = "test"
        let filter: [URLQueryItem]
        let apiType: APIType

        func decode(response: MockAPIModel) -> MockResponse {
            return response.mockResponse
        }

        init(apiType: APIType = .train) {
            self.apiType = apiType
            self.filter = []
        }
    }

    // MARK: - API Tests

    @Test("API with custom caller receives response")
    func testAPIWithCustomCaller() async throws {
        // Given
        let expectedResponse = MockResponse(message: "Success", data: "test data")
        let mockModel = MockAPIModel(mockResponse: expectedResponse)
        let responseData = try JSONEncoder().encode(mockModel)
        let caller = Self.mockCaller(returning: responseData, response: Self.successResponse())
        let api = CTAAPI(busKey: testBusKey, trainKey: testTrainKey, caller: caller)

        // When
        let resource = TestDecodableResource()
        let result = try await api.get(resource: resource)

        // Then
        #expect(result == expectedResponse)
    }

    @Test("API propagates network errors")
    @MainActor
    func testAPIPropagatesNetworkErrors() async throws {
        // Given
        let expectedError = MockError(description: "Network error")
        let caller = Self.failingCaller(error: expectedError)
        let api = CTAAPI(busKey: testBusKey, trainKey: testTrainKey, caller: caller)

        // When/Then
        let resource = TestDecodableResource()
        do {
            _ = try await api.get(resource: resource)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is MockError, "Expected MockError but got \(type(of: error))")
        }
    }

    @Test("API handles successful responses with non-200 status codes")
    @MainActor
    func testAPIHandlesNon200StatusCodes() async throws {
        // Given
        // Create a valid JSON that matches our MockAPIModel structure
        let testResponse = MockResponse(message: "Success", data: "test")
        let mockModel = MockAPIModel(mockResponse: testResponse)
        let testData = try JSONEncoder().encode(mockModel)

        // Create a response with a non-200 status code but valid data
        let response = Self.errorResponse(statusCode: 401)
        let caller = Self.mockCaller(returning: testData, response: response)
        let api = CTAAPI(busKey: testBusKey, trainKey: testTrainKey, caller: caller)

        // When/Then
        let resource = TestDecodableResource()
        // The API should still succeed as long as the data is valid JSON that matches our model
        let result = try await api.get(resource: resource)
        let expected = MockResponse(message: "Success", data: "test")
        #expect(result == expected, "Expected the decoded result to match the mock response")
    }

    @Test("API adds correct API key based on resource type")
    func testAPIAddsCorrectAPIKey() async throws {
        // Given
        let testResponse = MockResponse(message: "Success", data: "test")
        let mockModel = MockAPIModel(mockResponse: testResponse)
        let testData = try JSONEncoder().encode(mockModel)

        // Actor to safely capture URLs
        actor URLCapturer {
            private(set) var capturedURL: URL?

            func capture(_ url: URL) {
                capturedURL = url
            }
        }

        // Test bus API key
        let busCapturer = URLCapturer()
        let busCaller: @Sendable (URL) async throws -> (Data, URLResponse) = { [testData] url in
            await busCapturer.capture(url)
            return (testData, await Self.successResponse())
        }

        let busKey = "bus123"
        let trainKey = "train456"
        let busAPI = CTAAPI(busKey: busKey, trainKey: trainKey, caller: busCaller)

        // When - Test bus resource
        let busResource = TestDecodableResource(apiType: .bus)
        _ = try await busAPI.get(resource: busResource)

        // Then - Should use bus key
        let busURL = await busCapturer.capturedURL
        #expect(busURL?.absoluteString.contains("key=\(busKey)") == true)

        // Test train API key
        let trainCapturer = URLCapturer()
        let trainCaller: @Sendable (URL) async throws -> (Data, URLResponse) = { [testData] url in
            await trainCapturer.capture(url)
            return (testData, await Self.successResponse())
        }

        let trainAPI = CTAAPI(busKey: busKey, trainKey: trainKey, caller: trainCaller)

        // When - Test train resource
        let trainResource = TestDecodableResource(apiType: .train)
        _ = try await trainAPI.get(resource: trainResource)

        // Then - Should use train key
        let trainURL = await trainCapturer.capturedURL
        #expect(trainURL?.absoluteString.contains("key=\(trainKey)") == true)
    }

    @Test("API with custom caller receives response with direct data")
    func testAPIWithCustomCallerDirectData() async throws {
        // Given
        let expectedResponse = MockResponse(message: "Success", data: "test data")
        let mockModel = MockAPIModel(mockResponse: expectedResponse)
        let responseData = try JSONEncoder().encode(mockModel)
        let caller = Self.mockCaller(returning: responseData, response: Self.successResponse())
        let api = CTAAPI(busKey: testBusKey, trainKey: testTrainKey, caller: caller)

        // When
        let resource = TestDecodableResource()
        let result = try await api.get(resource: resource)

        // Then
        #expect(result == expectedResponse)
    }

    @Test("TrainArrivalResource URL construction with mapId")
    func testTrainArrivalResourceWithMapId() {
        let mapId = "12345"
        let resource = TrainArrivalResource(mapid: mapId)
        let url = resource.url

        // Check that the URL contains the expected components
        #expect(url.absoluteString.contains("ttarrivals.aspx") == true)
        #expect(url.absoluteString.contains("mapid=\(mapId)") == true)
        #expect(url.absoluteString.contains("outputType=JSON") == true)
    }

    @Test("TrainArrivalResource URL construction with stopId")
    func testTrainArrivalResourceWithStopId() {
        let stopId = "67890"
        let resource = TrainArrivalResource(stpid: stopId)
        let url = resource.url

        // Check that the URL contains the expected components
        #expect(url.absoluteString.contains("ttarrivals.aspx") == true)
        #expect(url.absoluteString.contains("stpid=\(stopId)") == true)
        #expect(url.absoluteString.contains("outputType=JSON") == true)
    }

    @Test("APIResource URL construction for bus")
    func testBusResourceURL() {
        struct TestBusResource: APIResource {
            var methodPath = "test"
            var filter: [URLQueryItem] = []
            var apiType: APIType = .bus

            func decode(response: TestResponse) -> String { "" }
        }

        struct TestResponse: Decodable, EmptyInit {
            static func initEmpty() -> TestResponse { TestResponse() }
        }

        let resource = TestBusResource()
        let url = resource.url

        // Check that the URL contains the expected components for bus API
        #expect(url.absoluteString.hasPrefix("https://www.ctabustracker.com/bustime/api/v3/test"))
        #expect(url.absoluteString.contains("format=json") == true)
    }

    @Test("APIResource URL construction for train with filters")
    func testTrainResourceURLWithFilters() {
        struct TestTrainResource: APIResource {
            var methodPath = "test"
            var filter: [URLQueryItem]
            var apiType: APIType = .train

            init(filter: [URLQueryItem]) {
                self.filter = filter
            }

            func decode(response: TestResponse) -> String { "" }
        }

        struct TestResponse: Decodable, EmptyInit {
            static func initEmpty() -> TestResponse { TestResponse() }
        }

        let filter = [URLQueryItem(name: "test", value: "value")]
        let resource = TestTrainResource(filter: filter)
        let url = resource.url

        // Check that the URL contains the expected components for train API
        #expect(url.absoluteString.hasPrefix("https://lapi.transitchicago.com/api/1.0/test"))
        #expect(url.absoluteString.contains("outputType=JSON") == true)
        #expect(url.absoluteString.contains("test=value") == true)
    }
}
