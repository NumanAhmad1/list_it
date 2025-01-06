// To parse this JSON data, do
//
//     final getCategoryListingModel = getCategoryListingModelFromJson(jsonString);

import 'dart:convert';

List<GetCategoryListingModel> getCategoryListingModelFromJson(String str) =>
    List<GetCategoryListingModel>.from(
        json.decode(str).map((x) => GetCategoryListingModel.fromJson(x)));

String getCategoryListingModelToJson(List<GetCategoryListingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCategoryListingModel {
  String bodyType;
  String descriptionOfCars;
  String doors;
  String emirates;
  String engineCapacityCc;
  String exteriorColor;
  Extras extras;
  String fuel;
  String horsePower;
  String id;
  String interiorColor;
  String isYourCarInsuredInUae;
  String kilometers;
  String locateYourCar;
  String makeModel;
  String mechanicalCondition;
  String noOfCylinders;
  String phoneNumber;
  String pictures;
  String price;
  String regionalSpec;
  String seatingCapacity;
  String steeringSide;
  String title;
  String transmissionType;
  String trim;
  String warranty;
  String year;

  GetCategoryListingModel({
    required this.bodyType,
    required this.descriptionOfCars,
    required this.doors,
    required this.emirates,
    required this.engineCapacityCc,
    required this.exteriorColor,
    required this.extras,
    required this.fuel,
    required this.horsePower,
    required this.id,
    required this.interiorColor,
    required this.isYourCarInsuredInUae,
    required this.kilometers,
    required this.locateYourCar,
    required this.makeModel,
    required this.mechanicalCondition,
    required this.noOfCylinders,
    required this.phoneNumber,
    required this.pictures,
    required this.price,
    required this.regionalSpec,
    required this.seatingCapacity,
    required this.steeringSide,
    required this.title,
    required this.transmissionType,
    required this.trim,
    required this.warranty,
    required this.year,
  });

  factory GetCategoryListingModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryListingModel(
        bodyType: json["Body Type"] ?? 'N/A',
        descriptionOfCars: json["Description of Cars"] ?? 'N/A',
        doors: json["Doors"] ?? 'N/A',
        emirates: json["Emirates"] ?? 'N/A',
        engineCapacityCc: json["Engine Capacity (cc)"] ?? 'N/A',
        exteriorColor: json["Exterior Color"] ?? 'N/A',
        extras: Extras.fromJson(json["Extras"] ?? {}),
        fuel: json["Fuel"] ?? 'N/A',
        horsePower: json["Horse Power"] ?? 'N/A',
        id: json["ID"] ?? 'N/A',
        interiorColor: json["Interior Color"] ?? 'N/A',
        isYourCarInsuredInUae: json["Is your Car insured in UAE"] ?? 'N/A',
        kilometers: json["Kilometers"] ?? 'N/A',
        locateYourCar: json["Locate your car"] ?? 'N/A',
        makeModel: json["Make & Model"] ?? 'N/A',
        mechanicalCondition: json["Mechanical Condition"] ?? 'N/A',
        noOfCylinders: json["No. of cylinders"] ?? 'N/A',
        phoneNumber: json["Phone Number"] ?? 'N/A',
        pictures: json["Add Pictures"] ?? 'N/A',
        price: json["Price"] ?? 'N/A',
        regionalSpec: json["Regional Spec"] ?? 'N/A',
        seatingCapacity: json["Seating Capacity"] ?? 'N/A',
        steeringSide: json["Steering Side"] ?? 'N/A',
        title: json["Title"] ?? 'N/A',
        transmissionType: json["Transmission Type"] ?? 'N/A',
        trim: json["Trim"] ?? 'N/A',
        warranty: json["Warranty"] ?? 'N/A',
        year: json["Year"] ?? 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "Body Type": bodyType,
        "Description of Cars": descriptionOfCars,
        "Doors": doors,
        "Emirates": emirates,
        "Engine Capacity (cc)": engineCapacityCc,
        "Exterior Color": exteriorColor,
        "Extras": extras.toJson(),
        "Fuel": fuel,
        "Horse Power": horsePower,
        "ID": id,
        "Interior Color": interiorColor,
        "Is your Car insured in UAE": isYourCarInsuredInUae,
        "Kilometers": kilometers,
        "Locate your car": locateYourCar,
        "Make & Model": makeModel,
        "Mechanical Condition": mechanicalCondition,
        "No. of cylinders": noOfCylinders,
        "Phone Number": phoneNumber,
        "Pictures": pictures,
        "Price": price,
        "Regional Spec": regionalSpec,
        "Seating Capacity": seatingCapacity,
        "Steering Side": steeringSide,
        "Title": title,
        "Transmission Type": transmissionType,
        "Trim": trim,
        "Warranty": warranty,
        "Year": year,
      };
}

class Extras {
  String climateControl;
  String keylessEntry;
  String navigationSystem;
  String? cooledSeats;
  String? dvdPlayer;
  String? frontWheelDrive;
  String? leatherSeats;
  String? parkingSensors;

  Extras({
    required this.climateControl,
    required this.keylessEntry,
    required this.navigationSystem,
    this.cooledSeats,
    this.dvdPlayer,
    this.frontWheelDrive,
    this.leatherSeats,
    this.parkingSensors,
  });

  factory Extras.fromJson(Map<String, dynamic> json) => Extras(
        climateControl: json["Climate Control"] ?? 'N/A',
        keylessEntry: json["Keyless Entry"] ?? 'N/A',
        navigationSystem: json["Navigation System"] ?? 'N/A',
        cooledSeats: json["Cooled Seats"] ?? 'N/A',
        dvdPlayer: json["DVD Player"] ?? 'N/A',
        frontWheelDrive: json["Front Wheel Drive"] ?? 'N/A',
        leatherSeats: json["Leather Seats"] ?? 'N/A',
        parkingSensors: json["Parking Sensors"] ?? 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "Climate Control": climateControl,
        "Keyless Entry": keylessEntry,
        "Navigation System": navigationSystem,
        "Cooled Seats": cooledSeats,
        "DVD Player": dvdPlayer,
        "Front Wheel Drive": frontWheelDrive,
        "Leather Seats": leatherSeats,
        "Parking Sensors": parkingSensors,
      };
}
