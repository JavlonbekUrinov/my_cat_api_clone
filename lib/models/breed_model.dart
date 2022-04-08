import 'dart:convert';

List<Breeds> breedsListFromJson(String str) =>
    List<Breeds>.from(json.decode(str).map((x) => Breeds.fromJson(x)));

String breedsToJson(List<Breeds> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Breeds {
  Breeds({
    required this.weight,
    required this.id,
    required this.name,
    required this.cfaUrl,
    required this.vetstreetUrl,
    required this.vcahospitalsUrl,
    required this.temperament,
    required this.origin,
    required this.countryCodes,
    required this.countryCode,
    required this.description,
    required this.lifeSpan,
    required this.indoor,
    required this.lap,
    required this.altNames,
    required this.adaptability,
    required this.affectionLevel,
    required this.childFriendly,
    required this.dogFriendly,
    required this.energyLevel,
    required this.grooming,
    required this.healthIssues,
    required this.intelligence,
    required this.sheddingLevel,
    required this.socialNeeds,
    required this.strangerFriendly,
    required this.vocalisation,
    required this.experimental,
    required this.hairless,
    required this.natural,
    required this.rare,
    required this.rex,
    required this.suppressedTail,
    required this.shortLegs,
    required this.wikipediaUrl,
    required this.hypoallergenic,
    required this.referenceImageId,
    required this.image,
    required this.catFriendly,
    required this.bidability,
  });

  Weight? weight;
  String? id;
  String? name;
  String? cfaUrl;
  String? vetstreetUrl;
  String? vcahospitalsUrl;
  String? temperament;
  String? origin;
  String? countryCodes;
  String? countryCode;
  String? description;
  String? lifeSpan;
  int? indoor;
  int? lap;
  String? altNames;
  int? adaptability;
  int? affectionLevel;
  int? childFriendly;
  int? dogFriendly;
  int? energyLevel;
  int? grooming;
  int? healthIssues;
  int? intelligence;
  int? sheddingLevel;
  int? socialNeeds;
  int? strangerFriendly;
  int? vocalisation;
  int? experimental;
  int? hairless;
  int? natural;
  int? rare;
  int? rex;
  int? suppressedTail;
  int? shortLegs;
  String? wikipediaUrl;
  int? hypoallergenic;
  String? referenceImageId;
  Image? image;
  int? catFriendly;
  int? bidability;

  factory Breeds.fromJson(Map<String, dynamic> json) => Breeds(
        weight: (Weight.fromJson(json["weight"]) != null) ?Weight.fromJson(json["weight"]):null,
        id: json["id"],
        name: json["name"],
        cfaUrl: (json["cfa_url"] == null) ? null : json["cfa_url"],
        vetstreetUrl:
            (json["vetstreet_url"] == null) ? null : json["vetstreet_url"],
        vcahospitalsUrl: (json["vcahospitals_url"] == null)
            ? null
            : json["vcahospitals_url"],
        temperament: json["temperament"],
        origin: json["origin"],
        countryCodes: json["country_codes"],
        countryCode: json["country_code"],
        description: json["description"],
        lifeSpan: json["life_span"],
        indoor: json["indoor"],
        lap: (json["lap"] == null) ? null : json["lap"],
        altNames: (json["alt_names"] == null) ? null : json["alt_names"],
        adaptability: json["adaptability"],
        affectionLevel: json["affection_level"],
        childFriendly: json["child_friendly"],
        dogFriendly: json["dog_friendly"],
        energyLevel: json["energy_level"],
        grooming: json["grooming"],
        healthIssues: json["health_issues"],
        intelligence: json["intelligence"],
        sheddingLevel: json["shedding_level"],
        socialNeeds: json["social_needs"],
        strangerFriendly: json["stranger_friendly"],
        vocalisation: json["vocalisation"],
        experimental: json["experimental"],
        hairless: json["hairless"],
        natural: json["natural"],
        rare: json["rare"],
        rex: json["rex"],
        suppressedTail: json["suppressed_tail"],
        shortLegs: json["short_legs"],
        wikipediaUrl:
            (json["wikipedia_url"] == null) ? null : json["wikipedia_url"],
        hypoallergenic: json["hypoallergenic"],
        referenceImageId: (json["reference_image_id"] == null)
            ? null
            : json["reference_image_id"],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        catFriendly:
            (json["cat_friendly"] == null) ? null : json["cat_friendly"],
        bidability: (json["bidability"] == null) ? null : json["bidability"],
      );

  Map<String, dynamic> toJson() => {
        "weight": weight?.toJson(),
        "id": id,
        "name": name,
        "cfa_url": (cfaUrl == null) ? null : cfaUrl,
        "vetstreet_url": (vetstreetUrl == null) ? null : vetstreetUrl,
        "vcahospitals_url": (vcahospitalsUrl == null) ? null : vcahospitalsUrl,
        "temperament": temperament,
        "origin": origin,
        "country_codes": countryCodes,
        "country_code": countryCode,
        "description": description,
        "life_span": lifeSpan,
        "indoor": indoor,
        "lap": (lap == null) ? null : lap,
        "alt_names": (altNames == null) ? null : altNames,
        "adaptability": adaptability,
        "affection_level": affectionLevel,
        "child_friendly": childFriendly,
        "dog_friendly": dogFriendly,
        "energy_level": energyLevel,
        "grooming": grooming,
        "health_issues": healthIssues,
        "intelligence": intelligence,
        "shedding_level": sheddingLevel,
        "social_needs": socialNeeds,
        "stranger_friendly": strangerFriendly,
        "vocalisation": vocalisation,
        "experimental": experimental,
        "hairless": hairless,
        "natural": natural,
        "rare": rare,
        "rex": rex,
        "suppressed_tail": suppressedTail,
        "short_legs": shortLegs,
        "wikipedia_url": wikipediaUrl,
        "hypoallergenic": hypoallergenic,
        "reference_image_id": referenceImageId,
        "image": image == null ? null : image!.toJson(),
        "cat_friendly": catFriendly,
        "bidability": bidability,
      };
}

class Image {
  Image({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
  });

  String? id;
  int? width;
  int? height;
  String? url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: (json["id"] == null) ? null : json["id"],
        width: (json["width"] == null) ? null : json["width"],
        height: (json["height"] == null) ? null : json["height"],
        url: (json["url"] == null) ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "width": (width == null) ? null : width,
        "height": (height == null) ? null : height,
        "url": (url == null) ? null : url,
      };
}

class Weight {
  Weight({
    required this.imperial,
    required this.metric,
  });

  String? imperial;
  String? metric;

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
        imperial: (json["imperial"] != null) ?json["imperial"] :null,
        metric: (json["metric"] != null )? json["metric"] :null,
      );

  Map<String, dynamic> toJson() => {
        "imperial": imperial,
        "metric": metric,
      };
}
