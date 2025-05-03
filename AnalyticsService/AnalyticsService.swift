import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "9564eb43-298a-412f-b507-dceaf147c3b9") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: AnaliticEvent, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

