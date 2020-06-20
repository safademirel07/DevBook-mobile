import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRequest {
  Future<http.Response> fetchProfile(String profileID) async {
    String endpointUrl = profileID.length == 0 ? "me" : profileID;

    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.get(Constants.api_url + "/profile/${endpointUrl}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token.toString()}',
        });
  }

  Future<http.Response> profilePostRequest(
      Profile profile, String imageBase64) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    String jsonObject = json.encode(profile.toJson());

    if (imageBase64.length > 0) {
      String newJsonObject = jsonObject.substring(0, jsonObject.length - 1);
      newJsonObject += ',"uploadedPhoto" : "$imageBase64"}';
      jsonObject = newJsonObject;
    }

    return http.post(
      Constants.api_url + "/profile",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: jsonObject,
    );
  }

  Future<http.Response> addEducationRequest(Education education) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/profile/education",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(education.toJson()),
    );
  }

  Future<http.Response> removeEducationRequest(String educationID) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/profile/education/" + educationID,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> addExperienceRequest(Experience experience) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/profile/experience",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(experience.toJson()),
    );
  }

  Future<http.Response> removeExperienceRequest(String experienceID) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/profile/experience/" + experienceID,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> addRepositoryRequest(Repository repository) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/profile/repository",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(repository.toJson()),
    );
  }

  Future<http.Response> removeRepositoryRequest(String repositoryID) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/profile/repository/" + repositoryID,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> addSkillRequest(String skillName) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/profile/skill",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(<String, String>{
        'skillName': skillName,
      }),
    );
  }

  Future<http.Response> removeSkillRequest(String skillID) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/profile/skill/" + skillID,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> postSocialRequest(SocialMedia social) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/profile/social",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(social),
    );
  }
}
