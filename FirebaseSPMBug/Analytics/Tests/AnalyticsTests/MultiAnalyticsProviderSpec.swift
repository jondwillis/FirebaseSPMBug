import XCTest
@testable import Analytics

import Quick
import Nimble

class MultiAnalyticsProviderSpec: QuickSpec {
    override func spec() {
        describe("Multi Analytics Provider") {
            let testProvider1 = TestAnalyticsProvider()
            let testProvider2 = TestAnalyticsProvider()
            let providers = [testProvider1, testProvider2]
            let multiAnalyticsProvider = MultiAnalyticsProvider(providers: providers)

            it("calls all nested setUserId") {
                let expectedId = "1"
                multiAnalyticsProvider.setUserId(expectedId)
                let didSets = providers.map(\.didSetUserId)
                expect(didSets).toNot(beEmpty())
                expect(didSets.first(where: { !$0 })).to(beNil())
            }
        }
    }
}
