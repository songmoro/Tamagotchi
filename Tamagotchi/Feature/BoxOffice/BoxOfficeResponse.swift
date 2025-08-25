//
//  BoxOfficeResponse.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
}

struct BoxOfficeParameters: Encodable {
    let key, targetDt: String
}
