import XCTest
@testable import AnyMapper

final class AnyMapperTests: XCTestCase {

    private let mapper: AnyMapper = Mapper(source: ["id": 10, "name": "John", "age": "25", "sex": nil])

    func testSimpleMap() {
        do {
            // try to map Int value "id": 10 to Int type. Should be success
            let id: Int = try mapper.value(key: "id")
            XCTAssertEqual(id, 10)

            // try to map Int value "id": 10 to Optional<Int> type. Should be success
            let _id: Int? = try mapper.value(key: "id")
            XCTAssertEqual(_id, 10)
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map String value "name": "John" to Optional<String> type. Should be success
            let name: String? = try mapper.value(key: "name")
            XCTAssertEqual(name, "John")
        } catch { XCTFail("error - \(error)") }
    }

    func testNull() {
        do {
            // try to map String "sex": nil to Int type. Should be failure
            let sex: Int = try mapper.value(key: "sex")
            XCTFail("Must throw \(sex)")
        } catch {
            if case .incorrectType = error as? AnyMapperError {
                XCTAssert(true)
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map String value "sex": nil to Optional<Int> type.
            // Should be success because optional
            let sex: Int? = try mapper.value(key: "sex")
            XCTAssertNil(sex)
        } catch { XCTFail("error - \(error)") }
    }

    func testNoKey() {
        do {
            // try to map String "address": nil to String type.
            // Should be failure because no key "address"
            let address: String = try mapper.value(key: "address")
            XCTFail("Must throw \(address)")
        } catch {
            if case .noKey = error as? AnyMapperError {
                XCTAssert(true)
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map String "address": nil to String type.
            // Should be success because 'default' mapping options by default
            // is 'returnNilIfNoKey' 'returnNilIfCantMap'
            let address: String? = try mapper.value(key: "address")
            XCTAssertNil(address)
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map String "address": nil to String type.
            // Should be failure because no key "address" and options set to 'none'
            let address: String? = try mapper.value(key: "address", options: .none)
            XCTFail("Must throw \(String(describing: address))")
        } catch {
            if case .noKey = error as? AnyMapperError {
                XCTAssert(true)
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    func testMapStringToInt() {

        do {
            // try to map String "age": "25" to Int type. Should be failure
            let age: Int = try mapper.value(key: "age")
            XCTFail("Must throw \(age)")
        } catch {
            if case .incorrectType = error as? AnyMapperError {
                XCTAssert(true)
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map String value "age": "25" to Optional<Int> type.
            // Should be success because default mapping options by default
            // is 'returnNilIfNoKey' 'returnNilIfCantMap'
            let age: Int? = try mapper.value(key: "age")
            XCTAssertNil(age)
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map String value "age": "25" to Optional<Int> type.
            // Should be failure because mapping options set to 'none'
            let age: Int? = try mapper.value(key: "age", options: .none)
            XCTFail("Must throw \(String(describing: age))")
        } catch {
            if case .incorrectType = error as? AnyMapperError {
                XCTAssert(true)
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map String value "age": "25" to Int type.
            // Should be success because used transformer 'stringInt'
            let age: Int = try mapper.value(key: "age", transformer: .stringInt)
            XCTAssertEqual(age, 25)
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map String value "age": "25" to Optional<Int> type.
            // Should be success because used transformer 'stringInt'
            let age: Int? = try mapper.value(key: "age", transformer: .stringInt)
            XCTAssertEqual(age, 25)
        } catch { XCTFail("error - \(error)") }
    }

    func testMapStringToIntError() {
        let mapper: AnyMapper = Mapper(source: ["id_int": 10, "id": "10"])

        do {
            // try to map Int "id_int": 10 to Int type.
            // Should be failure because 'id_int' is Int
            let id: Int = try mapper.value(key: "id_int", transformer: .stringInt)
            XCTFail("Must throw \(id)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringInt'. Not 'String' value")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map String "id": "10" String type.
            // Should be failure because 'stringInt' map only to Int type
            let id: String = try mapper.value(key: "id", transformer: .stringInt)
            XCTFail("Must throw \(id)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringInt'. Not 'Int' return type")
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    func testStringDate() {
        let mapper: AnyMapper = Mapper(source: ["date": "2020-06-12"])
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        do {
            // try to map Int "date": "2020-06-12" to Date type. Should be success
            let date: Date = try mapper.value(key: "date", transformer: .stringDate(formatter: formatter))
            XCTAssertEqual(date, formatter.date(from: "2020-06-12"))
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map Int "date": "2020-06-12" to Date type. Should be success
            let date: Date? = try mapper.value(key: "date", transformer: .stringDate(formatter: formatter))
            XCTAssertEqual(date, formatter.date(from: "2020-06-12"))
        } catch { XCTFail("error - \(error)") }
    }

    func testStringDateError() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none

        do {
            // try to map Int "date": 20 to Date type.
            // Should be failure because "date" is not String
            let mapper: AnyMapper = Mapper(source: ["date": 20])
            let date: Date = try mapper.value(key: "date", transformer: .stringDate(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringDate'. Not 'String' value")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map Int "date": "2020-06-12" to Date type.
            // Should be failure because 'stringDate' map only to Date type
            let mapper: AnyMapper = Mapper(source: ["date": "2020-06-12"])
            let date: Int = try mapper.value(key: "date", transformer: .stringDate(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringDate'. Not 'Date' return type")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map Int "date": "2020" to Date type.
            // Should be failure because "date" value not correct for date format "yyyy-MM-dd"
            let mapper: AnyMapper = Mapper(source: ["date": "2020"])
            let date: Date = try mapper.value(key: "date", transformer: .stringDate(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringDate'. Can't formatting for 'Date'")
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    func teststringISO8601Date() {
        let mapper: AnyMapper = Mapper(source: ["date": "2020-06-12"])
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate

        do {
            // try to map Int "date": "2020-06-12" to Date type. Should be success
            let date: Date = try mapper.value(key: "date", transformer: .stringISO8601Date(formatter: formatter))
            XCTAssertEqual(date, formatter.date(from: "2020-06-12"))
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map Int "date": "2020-06-12" to Date type. Should be success
            let date: Date? = try mapper.value(key: "date", transformer: .stringISO8601Date(formatter: formatter))
            XCTAssertEqual(date, formatter.date(from: "2020-06-12"))
        } catch { XCTFail("error - \(error)") }
    }

    func teststringISO8601DateError() {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .none
        formatter.formatOptions = .withFullDate

        do {
            // try to map Int "date": 20 to Date type.
            // Should be failure because "date" is not String
            let mapper: AnyMapper = Mapper(source: ["date": 20])
            let date: Date = try mapper.value(key: "date", transformer: .stringISO8601Date(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringISO8601Date'. Not 'String' value")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map Int "date": "2020-06-12" to Date type.
            // Should be failure because 'stringISO8601Date' map only to Date type
            let mapper: AnyMapper = Mapper(source: ["date": "2020-06-12"])
            let date: Int = try mapper.value(key: "date", transformer: .stringISO8601Date(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringISO8601Date'. Not 'Date' return type")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            // try to map Int "date": "2020" to Date type.
            // Should be failure because "date" value not correct for date format "yyyy-MM-dd"
            let mapper: AnyMapper = Mapper(source: ["date": "2020"])
            let date: Date = try mapper.value(key: "date", transformer: .stringISO8601Date(formatter: formatter))
            XCTFail("Must throw \(date)")
        } catch {
            if case let .incorrect(message, _, _, _) = error as? AnyMapperError {
                XCTAssertEqual(message, "Can't use 'stringISO8601Date'. Can't formatting for 'Date'")
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    func testReplace() {
        let mapper: AnyMapper = Mapper(source: ["id": 10])

        do {
            // try to map Int value "id": 10 to Int type with replace to 20. Should be success
            let id: Int = try mapper.value(key: "id", transformer: .replace { 20 })
            XCTAssertEqual(id, 20)
        } catch { XCTFail("error - \(error)") }

        do {
            // try to map Int value "id1" which no key and then replace to 20. Should be success
            let id: Int? = try mapper.value(key: "id1", transformer: .replace { 20 })
            XCTAssertEqual(id, 20)
        } catch { XCTFail("error - \(error)") }
    }

    func testTransform() {

        do {
            let mapper: AnyMapper = Mapper(source: ["age": "23.62748"])
            // try to map String value "age": "23.62748" to Int type with transform. Should be success
            let age: Int = try mapper.value(key: "age", transformer: .transform {
                guard let value = $0 as? String else { return 0 }
                guard let age = Double(value) else { return 0 }
                return Int(age.rounded(.down))
            })
            XCTAssertEqual(age, 23)
        } catch { XCTFail("error - \(error)") }

        do {
            let mapper: AnyMapper = Mapper(source: ["age": nil])
            // try to map Optional value "age": nil to Optional<Int> transform. Should be success
            let age: Int? = try mapper.value(key: "age", transformer: .transform { _ in
                return 0 // transform not used because value is nil
            })
            XCTAssertEqual(age, nil)
        } catch { XCTFail("error - \(error)") }

        do {
            let mapper: AnyMapper = Mapper(source: ["age": nil])
            // try to map Optional value "age": nil to Optional<Int> transform. Should be success
            let age: Int = try mapper.value(key: "age", transformer: .transform { _ in
                return 0
            })
            XCTFail("Must throw \(age)")
        } catch {
            if case let .optionalValue(_, key, _) = error as? AnyMapperError {
                XCTAssertEqual(key, "age")
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    func testAnyMappable() {
        struct User: AnyMappable {
            let id: Int
            let name: String

            init(mapper: AnyMapper) throws {
                self.id = try mapper.value(key: "id")
                self.name = try mapper.value(key: "name")
            }
        }

        do {
            let user = try User(source: ["id": 1, "name": "John"])
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John")
        } catch {
            XCTFail("error - \(error)")
        }

        do {
            let user = try User(source: ["id": 1, "name": nil])
            XCTFail("Must throw - \(user)")

        } catch {
            if case let .incorrectType(key, _, _) = error as? AnyMapperError {
                XCTAssertEqual(key, "name")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            let source = NSMutableDictionary()
            source["id"] = 2
            source["name"] = "Sem"

            let user = try User(source: source)
            XCTAssertEqual(user.id, 2)
            XCTAssertEqual(user.name, "Sem")
        } catch {
            XCTFail("error - \(error)")
        }
    }

    func testAnyMappableSubdata() {

        struct User: AnyMappableSubdata {
            let id: Int
            let name: String
            let age: Int

            init(mapper: AnyMapper, subdata: AnyMapperSubdata) throws {
                self.id = try mapper.value(key: "id")
                self.name = try mapper.value(key: "name")
                self.age = try subdata.value(key: "age")
            }
        }

        do {
            let subdata = MapperSubdata()
            subdata.set(key: "age", value: 27)
            let user = try User(source: ["id": 1, "name": "John"], subdata: subdata)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John")
            XCTAssertEqual(user.age, 27)
        } catch {
            XCTFail("error - \(error)")
        }

        do {
            let user = try User(source: ["id": 1, "name": nil])
            XCTFail("Must throw - \(user)")

        } catch {
            if case let .incorrectType(key, _, _) = error as? AnyMapperError {
                XCTAssertEqual(key, "name")
            } else {
                XCTFail("error - \(error)")
            }
        }

        do {
            let source = NSMutableDictionary()
            source["id"] = 2
            source["name"] = "Sem"
            let subdata = MapperSubdata()
            subdata.set(key: "age", value: 32)

            let user = try User(source: source, subdata: subdata)
            XCTAssertEqual(user.id, 2)
            XCTAssertEqual(user.name, "Sem")
            XCTAssertEqual(user.age, 32)
        } catch {
            XCTFail("error - \(error)")
        }

        do {
            let user = try User(source: ["id": 1, "name": "John"])
            XCTFail("Must throw - \(user)")
        } catch {
            if case let .noKey(key, _) = error as? AnyMapperError {
                XCTAssertEqual(key, "age")
            } else {
                XCTFail("error - \(error)")
            }
        }
    }

    static var allTests = [
        ("testSimpleMap", testSimpleMap),
        ("testNull", testNull),
        ("testNoKey", testNoKey),
        ("testMapStringToInt", testMapStringToInt),
        ("testMapStringToIntError", testMapStringToIntError),
        ("testStringDate", testStringDate),
        ("testStringDateError", testStringDateError),
        ("teststringISO8601Date", teststringISO8601Date),
        ("teststringISO8601DateError", teststringISO8601DateError),
        ("testReplace", testReplace),
        ("testTransform", testTransform),
        ("testAnyMappable", testAnyMappable),
    ]
}
