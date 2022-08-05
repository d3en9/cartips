import Foundation
import SwiftUI
import MapKit

let driverMock = DriverInfo(
    driver: Driver(
        name: "Иванов Виктор Сергеевич",
        phone_number: "+7 343 343 11 22"
    ),
    auto: Auto(
        alarm_system: "StarLine",
        mileage: 32456,
        main_info: AutoMainInfo(
            body_type: "хэтчбек",
            model: "vw jetta",
            state_number: "123",
            vin_number: "123455",
            color: "синий",
            release_year: 2019,
            vrc_number: "123455"
            
        )
    ),
    favorite_autoservice: Autoservice(
        autoservice_name: "ТО и Ремонт",
        location: Location(
            address: "г. Москва, Гончарная, 6",
            longitude: 37.644834,
            latitude: 55.745758))
)

let alarmSystemMock = AlarmSystem(
    parameters: [
        AlarmSystemParam(name: "gsm", description: "Уровень приема сигнала", value: "6", unit: "lvl", active: false),
        AlarmSystemParam(name: "temp_none", description: "Температура с неизвестного датчика", value: "42", unit: "°С", active: false),
        AlarmSystemParam(name: "gsm", description: "Уровень приема сигнала", value: "6", unit: "lvl", active: false)
                ],
    last_gps: XYCoordinate(x: 56.304316666666665, y: 44.07958333333333),
    message: "ok"
)

let replacementParametersMock = ReplacementParametersResponse(
    replacement_parameters: [
        ReplacementParameter(
            id: 1,
            titles: ReplacementParameterTitle(name: "Масло в двигателе", list_name: "масла в двигателе", add_info_name: "масла в двигателе"),
            def_value: 15000,
            cur_value: 8194,
            unit: "km",
            state: .replaceAfter,
            active: false),
        ReplacementParameter(
            id: 2,
            titles: ReplacementParameterTitle(name: "Масло в двигателе", list_name: "масла в двигателе", add_info_name: "масла в двигателе"),
            def_value: 15000,
            cur_value: 8194,
            unit: "km",
            state: .replaceAfter,
            active: false),
        ReplacementParameter(
            id: 3,
            titles: ReplacementParameterTitle(name: "Масло в двигателе", list_name: "масла в двигателе", add_info_name: "масла в двигателе"),
            def_value: 15000,
            cur_value: 8194,
            unit: "km",
            state: .replaceAfter,
            active: false),
    ]
)

extension AppState {
    static func Mock() -> AppState {
        let state = AppState()
        state.state = MainAppState.notAuth()
        state.driver = .loaded(driverMock)
        state.alarmSystem = .loaded(alarmSystemMock)
        state.replacements = .loaded(replacementParametersMock)
        let gps = alarmSystemMock.last_gps
        let coord = CLLocationCoordinate2D(latitude: gps.x, longitude: gps.y)
        state.mapRegion.center = coord
        state.markers[0] = Marker(location: MapMarker(coordinate: coord, tint: .blue))
        return state
        
    }
}
