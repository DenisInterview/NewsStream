//
//  NewsStream.swift
//  NewsStream
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import Foundation

class NewsStream: Codable {
    let items: Items?
    let more: More?
    let commentInfos: CommentInfos?
    
    enum CodingKeys: String, CodingKey {
        case items, more
        case commentInfos = "comment_infos"
    }
    
    init(items: Items?, more: More?, commentInfos: CommentInfos?) {
        self.items = items
        self.more = more
        self.commentInfos = commentInfos
    }
}

class CommentInfos: Codable {
    let result: [CommentInfosResult]?
    let error: JSONNull?
    
    init(result: [CommentInfosResult]?, error: JSONNull?) {
        self.result = result
        self.error = error
    }
}

class CommentInfosResult: Codable {
    let contextID: String?
    let count: Int?
    let enabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case contextID = "context_id"
        case count, enabled
    }
    
    init(contextID: String?, count: Int?, enabled: Bool?) {
        self.contextID = contextID
        self.count = count
        self.enabled = enabled
    }
}

class Items: Codable {
    let result: [ItemsResult]?
    let error: JSONNull?
    
    init(result: [ItemsResult]?, error: JSONNull?) {
        self.result = result
        self.error = error
    }
}

class ItemsResult: Codable {
    let uuid, clusterID, articleID, title: String?
    let type: TypeEnum?
    let link: String?
    let publishedAt, summary, author, publisher: String?
    let content: String?
    let mainImage: MainImage?
    let category, contextID: String?
    let embeddedVideos: [JSONAny]?
    let streams: [StreamElement]?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case clusterID = "cluster_id"
        case articleID = "article_id"
        case title, type, link
        case publishedAt = "published_at"
        case summary, author, publisher, content
        case mainImage = "main_image"
        case category
        case contextID = "context_id"
        case embeddedVideos = "embedded_videos"
        case streams
    }
    
    init(uuid: String?, clusterID: String?, articleID: String?, title: String?, type: TypeEnum?, link: String?, publishedAt: String?, summary: String?, author: String?, publisher: String?, content: String?, mainImage: MainImage?, category: String?, contextID: String?, embeddedVideos: [JSONAny]?, streams: [StreamElement]?) {
        self.uuid = uuid
        self.clusterID = clusterID
        self.articleID = articleID
        self.title = title
        self.type = type
        self.link = link
        self.publishedAt = publishedAt
        self.summary = summary
        self.author = author
        self.publisher = publisher
        self.content = content
        self.mainImage = mainImage
        self.category = category
        self.contextID = contextID
        self.embeddedVideos = embeddedVideos
        self.streams = streams
    }
}

class MainImage: Codable {
    let originalURL: String?
    let originalWidth, originalHeight: Int?
    let resolutions: [Resolution]?
    
    enum CodingKeys: String, CodingKey {
        case originalURL = "original_url"
        case originalWidth = "original_width"
        case originalHeight = "original_height"
        case resolutions
    }
    
    init(originalURL: String?, originalWidth: Int?, originalHeight: Int?, resolutions: [Resolution]?) {
        self.originalURL = originalURL
        self.originalWidth = originalWidth
        self.originalHeight = originalHeight
        self.resolutions = resolutions
    }
}

class Resolution: Codable {
    let url: String?
    let width, height: Int?
    let tag: Tag?
    
    init(url: String?, width: Int?, height: Int?, tag: Tag?) {
        self.url = url
        self.width = width
        self.height = height
        self.tag = tag
    }
}

enum Tag: String, Codable {
    case fitHeight320 = "fit-height-320"
    case fitWidth640 = "fit-width-640"
    case square140X140 = "square-140x140"
}

class StreamElement: Codable {
    let uuid: String?
    
    init(uuid: String?) {
        self.uuid = uuid
    }
}

enum TypeEnum: String, Codable {
    case cavideo = "cavideo"
    case story = "story"
}

class More: Codable {
    let result: [StreamElement]?
    let error: JSONNull?
    
    init(result: [StreamElement]?, error: JSONNull?) {
        self.result = result
        self.error = error
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func newsStreamTask(with url: URL, completionHandler: @escaping (NewsStream?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
