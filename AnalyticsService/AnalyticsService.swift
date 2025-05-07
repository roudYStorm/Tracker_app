import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "2227a438-d4c4-48d7-a7d0-184268159d42") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: AnaliticEvent, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

