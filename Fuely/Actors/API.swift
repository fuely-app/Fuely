//
//  API.swift
//  Fuely
//
//  Created by Jarrod Norwell on 22/5/2026.
//

import Foundation
import UIKit
import XMLCoder

typealias Result = (items: [API.Item], buildDate: String?, brand: API.Brand?, product: API.Product?,
                    region: API.Region?, suburb: API.Suburb?, surrounding: Bool?, day: API.Day?)
actor API {
    // MARK: Brand
    enum Brand : String, CaseIterable, Codable, Comparable {
        static func < (lhs: Brand, rhs: Brand) -> Bool {
            lhs.string.localizedCaseInsensitiveCompare(rhs.string) == .orderedAscending
        }
        
        case vibe = "Vibe",
             costco = "Costco",
             atlas = "Atlas",
             burk = "Burk",
             xConvenience = "X Convenience",
             liberty = "Liberty",
             shell = "Shell",
             united = "United",
             caltex = "Caltex",
             petroFuels = "Petro Fuels",
             sevenEleven = "7-Eleven",
             fastFuel247 = "FastFuel 24/7",
             egAmpol = "EG Ampol",
             ampol = "Ampol",
             independent = "Independent",
             metroPetroleum = "Metro Petroleum",
             ugo = "UGO",
             omgCaltex = "OMG Caltex",
             omgMetro = "OMG Metro",
             bp = "BP",
             betterChoice = "Better Choice",
             reddyExpress = "Reddy Express",
             astron = "Astron",
             eagle = "Eagle",
             solo = "Solo",
             maiseyFuels = "Maisey Fuels",
             dunnings = "Dunning's",
             gull = "Gull",
             phoenix = "Phoenix",
             fuelTech = "FuelTech",
             waFuels = "WA Fuels",
             fdwa = "FDWA",
             mobil = "Mobil",
             perrys = "Perrys",
             puma = "Puma",
             cglFuel = "CGL Fuel",
             questFuel = "Quest Fuel",
             ior = "IOR",
             mogas = "Mogas"
             
        
        var id: Int? {
            switch self {
            case .sevenEleven: 29
            case .ampol: 2
            case .astron: 41
            case .atlas: 34
            case .betterChoice: 3
            case .bp: 5
            case .burk: 39
            case .caltex: 6
            case .cglFuel: 36
            case .costco: 32
            case .dunnings: 44
            case .eagle: 24
            case .egAmpol: 35
            case .fastFuel247: 25
            case .fuelTech: 53
            case .gull: 7
            case .independent: 15
            case .liberty: 10
            case .maiseyFuels: 47
            case .metroPetroleum: 30
            case .mobil: 11
            case .omgCaltex: 48
            case .omgMetro: 49
            case .perrys: 45
            case .petroFuels: 40
            case .phoenix: 38
            case .puma: 26
            case .reddyExpress: 43
            case .shell: 14
            case .solo: 50
            case .ugo: 46
            case .united: 23
            case .vibe: 27
            case .waFuels: 31
            case .xConvenience: 37
            case .fdwa,
                    .ior,
                    .mogas,
                    .questFuel:
                nil
            }
        }
        
        var integerString: String { .init(id ?? 0) }
        var string: String { rawValue }
    }
    
    // MARK: Product
    enum Product : Int, CaseIterable, Codable, Comparable {
        static func < (lhs: Product, rhs: Product) -> Bool {
            lhs.description.localizedCaseInsensitiveCompare(rhs.description) == .orderedAscending
        }
        
        case unleadedPetrol = 1,
             premiumUnleaded = 2,
             diesel = 4,
             lpg = 5,
             ron98 = 6,
             e85 = 10,
             brandDiesel = 11

        var description: String {
            switch self {
            case .unleadedPetrol: "Unleaded Petrol"
            case .premiumUnleaded: "Premium Unleaded"
            case .diesel: "Diesel"
            case .lpg: "LPG"
            case .ron98: "98 RON"
            case .e85: "E85"
            case .brandDiesel: "Brand Diesel"
            }
        }
        
        var integer: Int { rawValue }
        var string: String { "\(integer)" }
    }
    
    // MARK: Region
    enum Region : Int, CaseIterable, Codable, Comparable {
        static func < (lhs: Region, rhs: Region) -> Bool {
            lhs.description.localizedCaseInsensitiveCompare(rhs.description) == .orderedAscending
        }
        
        case boulder = 1,
             broome = 2,
             busseltonTownsite = 3,
             carnarvon = 4,
             collie = 5,
             dampier = 6,
             esperance = 7,
             kalgoorlie = 8,
             karratha = 9,
             kununurra = 10,
             narrogin = 11,
             northam = 12,
             portHedland = 13,
             southHedland = 14,
             albany = 15,
             bunbury = 16,
             geraldton = 17,
             mandurah = 18,
             capel = 19,
             dardanup = 20,
             greenough = 21,
             harvey = 22,
             murray = 23,
             waroona = 24,
             metroNorthOfRiver = 25,
             metroSouthOfRiver = 26,
             metroEastHills = 27,
             augustaMargaretRiver = 28,
             busseltonShire = 29,
             bridgetownGreenbushes = 30,
             donnybrookBalingup = 31,
             manjimup = 32,
             cataby = 33,
             coolgardie = 34,
             cunderdin = 35,
             dalwallinu = 36,
             denmark = 37,
             derby = 38,
             dongara = 39,
             exmouth = 40,
             fitzroyCrossing = 41,
             jurien = 42,
             kambalda = 43,
             kellerberrin = 44,
             kojonup = 45,
             meekatharra = 46,
             moora = 47,
             mountBarker = 48,
             newman = 49,
             norseman = 50,
             ravensthorpe = 51,
             bodallin = 63,
             northamShire = 62,
             tammin = 53,
             williams = 54,
             wubin = 55,
             york = 56,
             regansFord = 57,
             meckering = 58,
             wundowie = 59,
             northBannister = 60,
             munglinup = 61

        var description: String {
            switch self {
            case .boulder: "Boulder"
            case .broome: "Broome"
            case .busseltonTownsite: "Busselton (Townsite)"
            case .carnarvon: "Carnarvon"
            case .collie: "Collie"
            case .dampier: "Dampier"
            case .esperance: "Esperance"
            case .kalgoorlie: "Kalgoorlie"
            case .karratha: "Karratha"
            case .kununurra: "Kununurra"
            case .narrogin: "Narrogin"
            case .northam: "Northam"
            case .portHedland: "Port Hedland"
            case .southHedland: "South Hedland"
            case .albany: "Albany"
            case .bunbury: "Bunbury"
            case .geraldton: "Geraldton"
            case .mandurah: "Mandurah"
            case .capel: "Capel"
            case .dardanup: "Dardanup"
            case .greenough: "Greenough"
            case .murray: "Murray"
            case .waroona: "Waroona"
            case .metroNorthOfRiver: "Metro : North of River"
            case .metroSouthOfRiver: "Metro : South of River"
            case .metroEastHills: "Metro : East/Hills"
            case .augustaMargaretRiver: "Augusta / Margaret River"
            case .busseltonShire: "Busselton (Shire)"
            case .bridgetownGreenbushes: "Bridgetown / Greenbushes"
            case .donnybrookBalingup: "Donnybrook / Balingup"
            case .manjimup: "Manjimup"
            case .cataby: "Cataby"
            case .cunderdin: "Cunderdin"
            case .dalwallinu: "Dalwallinu"
            case .denmark: "Denmark"
            case .derby: "Derby"
            case .dongara: "Dongara"
            case .exmouth: "Exmouth"
            case .fitzroyCrossing: "Fitzroy Crossing"
            case .jurien: "Jurien"
            case .kambalda: "Kambalda"
            case .kellerberrin: "Kellerberrin"
            case .kojonup: "Kojonup"
            case .meekatharra: "Meekatharra"
            case .moora: "Moora"
            case .newman: "Newman"
            case .norseman: "Norseman"
            case .ravensthorpe: "Ravensthorpe"
            case .tammin: "Tammin"
            case .williams: "Williams"
            case .wubin: "Wubin"
            case .york: "York"
            case .regansFord: "Regans Ford"
            case .meckering: "Meckering"
            case .wundowie: "Wundowie"
            case .northBannister: "North Bannister"
            case .munglinup: "Munglinup"
            case .harvey: "Harvey"
            case .coolgardie: "Coolgardie"
            case .mountBarker: "Mount Barker"
            case .bodallin: "Bodallin"
            case .northamShire: "Northam Shire"
            }
        }
        
        var integer: Int { rawValue }
        var string: String { "\(integer)" }
    }
    
    // MARK: Suburb
    enum Suburb : String, CaseIterable, Codable, Comparable {
        static func < (lhs: Suburb, rhs: Suburb) -> Bool {
            lhs.string.localizedCaseInsensitiveCompare(rhs.string) == .orderedAscending
        }
        
        case albany = "Albany",
             alexanderHeights = "Alexander Heights",
             alfredCove = "Alfred Cove",
             applecross = "Applecross",
             armadale = "Armadale",
             ascot = "Ascot",
             attadale = "Attadale",
             augusta = "Augusta",
             australind = "Australind",
             balcatta = "Balcatta",
             baldivis = "Baldivis",
             balga = "Balga",
             balingup = "Balingup",
             ballajura = "Ballajura",
             barragup = "Barragup",
             baskerville = "Baskerville",
             bassendean = "Bassendean",
             bayswater = "Bayswater",
             beckenham = "Beckenham",
             bedfordale = "Bedfordale",
             beechboro = "Beechboro",
             beldon = "Beldon",
             bellevue = "Bellevue",
             belmont = "Belmont",
             benger = "Benger",
             bentley = "Bentley",
             bertram = "Bertram",
             bibraLake = "Bibra Lake",
             bicton = "Bicton",
             binningup = "Binningup",
             boulder = "Boulder",
             bouvard = "Bouvard",
             boyanup = "Boyanup",
             brentwood = "Brentwood",
             bridgetown = "Bridgetown",
             broome = "Broome",
             brunswickJunction = "Brunswick Junction",
             bullCreek = "Bull Creek",
             bullsbrook = "Bullsbrook",
             bunbury = "Bunbury",
             burswood = "Burswood",
             busselton = "Busselton",
             byford = "Byford",
             canningVale = "Canning Vale",
             cannington = "Cannington",
             capel = "Capel",
             carbunupRiver = "Carbunup River",
             carine = "Carine",
             carlisle = "Carlisle",
             carnarvon = "Carnarvon",
             cataby = "Cataby",
             caversham = "Caversham",
             chidlow = "Chidlow",
             claremont = "Claremont",
             clarkson = "Clarkson",
             cloverdale = "Cloverdale",
             collie = "Collie",
             como = "Como",
             coolgardie = "Coolgardie",
             coolup = "Coolup",
             cottesloe = "Cottesloe",
             cowaramup = "Cowaramup",
             cunderdin = "Cunderdin",
             currambine = "Currambine",
             dalwallinu = "Dalwallinu",
             dampier = "Dampier",
             dardanup = "Dardanup",
             dawesville = "Dawesville",
             denmark = "Denmark",
             derby = "Derby",
             dianella = "Dianella",
             dongara = "Dongara",
             donnybrook = "Donnybrook",
             doubleview = "Doubleview",
             duncraig = "Duncraig",
             dunsborough = "Dunsborough",
             dwellingup = "Dwellingup",
             eastFremantle = "East Fremantle",
             eastPerth = "East Perth",
             eastVictoriaPark = "East Victoria Park",
             eaton = "Eaton",
             edgewater = "Edgewater",
             ellenbrook = "Ellenbrook",
             erskine = "Erskine",
             esperance = "Esperance",
             exmouth = "Exmouth",
             falcon = "Falcon",
             fitzroyCrossing = "Fitzroy Crossing",
             floreat = "Floreat",
             forrestdale = "Forrestdale",
             forrestfield = "Forrestfield",
             fremantle = "Fremantle",
             gelorup = "Gelorup",
             geraldton = "Geraldton",
             gidgegannup = "Gidgegannup",
             girrawheen = "Girrawheen",
             glenForrest = "Glen Forrest",
             glendalough = "Glendalough",
             glenfield = "Glenfield",
             gnangara = "Gnangara",
             goldenBay = "Golden Bay",
             gosnells = "Gosnells",
             gracetown = "Gracetown",
             greenbushes = "Greenbushes",
             greenough = "Greenough",
             greenwood = "Greenwood",
             guildford = "Guildford",
             gwelup = "Gwelup",
             hallsHead = "Halls Head",
             hamiltonHill = "Hamilton Hill",
             harvey = "Harvey",
             herneHill = "Herne Hill",
             highWycombe = "High Wycombe",
             highgate = "Highgate",
             hillarys = "Hillarys",
             huntingdale = "Huntingdale",
             innaloo = "Innaloo",
             jandakot = "Jandakot",
             jolimont = "Jolimont",
             joondalup = "Joondalup",
             jurienBay = "Jurien Bay",
             kalamunda = "Kalamunda",
             kalgoorlie = "Kalgoorlie",
             kambalda = "Kambalda",
             karawara = "Karawara",
             kardinya = "Kardinya",
             karragullen = "Karragullen",
             karratha = "Karratha",
             karridale = "Karridale",
             karrinyup = "Karrinyup",
             kellerberrin = "Kellerberrin",
             kelmscott = "Kelmscott",
             kewdale = "Kewdale",
             kiara = "Kiara",
             kingsley = "Kingsley",
             kirup = "Kirup",
             kojonup = "Kojonup",
             koondoola = "Koondoola",
             kununurra = "Kununurra",
             kwinana = "Kwinana",
             lakelands = "Lakelands",
             langford = "Langford",
             leda = "Leda",
             leederville = "Leederville",
             leeming = "Leeming",
             lesmurdie = "Lesmurdie",
             lynwood = "Lynwood",
             maddington = "Maddington",
             madeley = "Madeley",
             malaga = "Malaga",
             mandurah = "Mandurah",
             manjimup = "Manjimup",
             manning = "Manning",
             manypeaks = "Manypeaks",
             margaretRiver = "Margaret River",
             meadowSprings = "Meadow Springs",
             meekatharra = "Meekatharra",
             merriwa = "Merriwa",
             middleSwan = "Middle Swan",
             midvale = "Midvale",
             mindarie = "Mindarie",
             mirrabooka = "Mirrabooka",
             moonyoonooka = "Moonyoonooka",
             moora = "Moora",
             morley = "Morley",
             mosmanPark = "Mosman Park",
             mountBarker = "Mount Barker",
             mtHawthorn = "Mt Hawthorn",
             mtHelena = "Mt Helena",
             mtLawley = "Mt Lawley",
             mtPleasant = "Mt Pleasant",
             mullaloo = "Mullaloo",
             mundaring = "Mundaring",
             mundijong = "Mundijong",
             munster = "Munster",
             murdoch = "Murdoch",
             myalup = "Myalup",
             myaree = "Myaree",
             narrogin = "Narrogin",
             navalBase = "Naval Base",
             nedlands = "Nedlands",
             neerabup = "Neerabup",
             newman = "Newman",
             nollamara = "Nollamara",
             noranda = "Noranda",
             norseman = "Norseman",
             northDandalup = "North Dandalup",
             northFremantle = "North Fremantle",
             northPerth = "North Perth",
             northam = "Northam",
             northbridge = "Northbridge",
             northcliffe = "Northcliffe",
             novergup = "Nowergup",
             oConner = "O'Conner",
             oceanReef = "Ocean Reef",
             osbornePark = "Osborne Park",
             padbury = "Padbury",
             palmyra = "Palmyra",
             parmelia = "Parmelia",
             pearsall = "Pearsall",
             pemberton = "Pemberton",
             perth = "Perth",
             picton = "Picton",
             pinjarra = "Pinjarra",
             portHedland = "Port Hedland",
             portKennedy = "Port Kennedy",
             prestonBeach = "Preston Beach",
             quinnsRock = "Quinns Rock",
             ravensthorpe = "Ravensthorpe",
             redcliffe = "Redcliffe",
             redmond = "Redmond",
             ridgewood = "Ridgewood",
             riverton = "Riverton",
             rivervale = "Rivervale",
             rockingham = "Rockingham",
             roleystone = "Roleystone",
             rosaBrook = "Rosa Brook",
             rottnestIsland = "Rottnest Island",
             sawyersValley = "Sawyers Valley",
             scarborough = "Scarborough",
             secretHarbour = "Secret Harbour",
             serpentine = "Serpentine",
             singleton = "Singleton",
             sorrento = "Sorrento",
             southFremantle = "South Fremantle",
             southHedland = "South Hedland",
             southLake = "South Lake",
             southPerth = "South Perth",
             southYunderup = "South Yunderup",
             southernRiver = "Southern River",
             spearwood = "Spearwood",
             strathamDowns = "Stratham Downs",
             stratton = "Stratton",
             subiaco = "Subiaco",
             success = "Success",
             swanView = "Swan View",
             swanbourne = "Swanbourne",
             tammin = "Tammin",
             theLakes = "The Lakes",
             thornlie = "Thornlie",
             tuartHill = "Tuart Hill",
             upperSwan = "Upper Swan",
             vasse = "Vasse",
             victoriaPark = "Victoria Park",
             waikiki = "Waikiki",
             walpole = "Walpole",
             wangara = "Wangara",
             wanneroo = "Wanneroo",
             warnbro = "Warnbro",
             waroona = "Waroona",
             warwick = "Warwick",
             waterloo = "Waterloo",
             wattleGrove = "Wattle Grove",
             wedgefield = "Wedgefield",
             wellstead = "Wellstead",
             welshpool = "Welshpool",
             wembley = "Wembley",
             westPerth = "West Perth",
             westSwan = "West Swan",
             westfield = "Westfield",
             westminster = "Westminster",
             willetton = "Willetton",
             williams = "Williams",
             witchcliffe = "Witchcliffe",
             woodvale = "Woodvale",
             wooroloo = "Wooroloo",
             wubin = "Wubin",
             yanchep = "Yanchep",
             yokine = "Yokine",
             york = "York",
             youngSiding = "Young Siding",
             yunderup = "Yunderup"
        
        var string: String { rawValue }
    }
    
    // MARK: Day
    enum Day : Codable {
        case today,
             tomorrow,
             yesterday,
             exact(String)
        
        var string: String {
            switch self {
            case .today: "today"
            case .tomorrow: "tomorrow"
            case .yesterday: "yesterday"
            case .exact(let string): string
            }
        }
    }
    
    struct Item : Codable, Hashable, Comparable, Identifiable {
        static func < (lhs: API.Item, rhs: API.Item) -> Bool {
            lhs.brand.string.localizedCaseInsensitiveCompare(rhs.brand.string) == .orderedAscending
        }
        
        var id: UUID = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        let title: String
        let description: String
        let brand: Brand
        let date: String
        let price: Double
        let tradingName: String
        let location: String
        let address: String
        let phone: String
        let latitude: Double
        let longitude: Double

        enum CodingKeys: String, CodingKey {
            case title
            case description
            case brand
            case date
            case price
            case tradingName = "trading-name"
            case location
            case address
            case phone
            case latitude
            case longitude
        }
    }
    
    struct Response : Codable {
        struct Channel : Codable {
            let lastBuildDate: String
            let item: [Item]
        }
        
        let channel: Channel
    }
    
    enum Param : String, CaseIterable, Codable {
        case brand = "Brand",
            product = "Product",
            region = "Region",
            suburb = "Suburb",
            surrounding = "Surrounding",
            day = "Day"
        
        var string: String { rawValue }
        
        static var scopeTitles: [String] {
            var items: [Param] = Param.allCases
            items.removeLast(2)
            return items.map(\.string)
        }
    }
    
    let endpoint: String = "https://www.fuelwatch.wa.gov.au/fuelwatch/fuelWatchRSS?"
    
    init() {}
    
    func query(brand: Brand? = nil, product: Product? = nil, region: Region? = nil, suburb: Suburb? = nil,
               surrounding: Bool? = nil, day: Day? = nil) async throws -> Result {
        let components: URLComponents? = .init(string: endpoint)
        guard var components else {
            return ([], nil, nil, nil, nil, nil, nil, nil)
        }
        
        let surroundingBool: String? = if let surrounding {
            surrounding ? "yes" : "no"
        } else {
            nil
        }
        
        var queryItems: [URLQueryItem] = []
        addQueryItem(to: &queryItems, for: .brand, with: brand?.integerString)
        addQueryItem(to: &queryItems, for: .product, with: product?.string)
        addQueryItem(to: &queryItems, for: .region, with: region?.string)
        addQueryItem(to: &queryItems, for: .suburb, with: suburb?.string)
        addQueryItem(to: &queryItems, for: .surrounding, with: surroundingBool)
        addQueryItem(to: &queryItems, for: .day, with: day?.string)
        
        components.queryItems = queryItems
        guard let url = components.url else {
            return ([], nil, nil, nil, nil, nil, nil, nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder: XMLDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let response: Response = try decoder.decode(Response.self, from: data)
        
        return (response.channel.item.sorted(), response.channel.lastBuildDate,
                brand, product, region, suburb, surrounding, day)
    }
    
    private func addQueryItem(to queryItems: inout [URLQueryItem], for param: Param, with value: String? = nil) {
        guard let value else {
            return
        }
        
        queryItems.append(.init(name: param.string, value: value))
    }
}
