import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/models/get/user.dart';
import 'package:devbook_new/requests/profile_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ProfileProvider with ChangeNotifier {
  Profile profile;
  String errorMessage;
  bool loading = true;
  bool adding = false;

  ProfileProvider() {
    fetchProfile("");
  }
  bool createProfile = false;

  Future<void> fetchProfile(String userID) async {
    setLoading(true);

    profile = null;

    ProfileRequest().fetchProfile(userID).then((data) {
      if (data.statusCode == 200) {
        setCreateProfile(false);
        setProfile(Profile.fromJson(json.decode(data.body)));
      } else if (data.statusCode == 404) {
        setCreateProfile(true);
      } else {
        setCreateProfile(true);

        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result);
      }
    });
    setLoading(false);
  }

  void setCreateProfile(bool value) {
    createProfile = value;
    notifyListeners();
  }

  bool getCreateProfile() {
    return createProfile;
  }

  Future<bool> profilePostRequest(Profile profile, String imageBase64) async {
    setAdding(true);

    ProfileRequest().profilePostRequest(profile, imageBase64).then((data) {
      if (data.statusCode == 201 || data.statusCode == 200) {
        setAdding(false);
        fetchProfile("");

        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> addEducationRequest(Education education) async {
    setAdding(true);

    ProfileRequest().addEducationRequest(education).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        fetchProfile("");
        Education newEducation = Education.fromJson(json.decode(data.body));
        if (profile != null) {
          profile.education.add(newEducation);
        }
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> removeEducationRequest(String educationID) async {
    setAdding(true);

    ProfileRequest().removeEducationRequest(educationID).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        fetchProfile("");
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> addExperienceRequest(Experience experience) async {
    setAdding(true);

    ProfileRequest().addExperienceRequest(experience).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        Experience newExperience = Experience.fromJson(json.decode(data.body));
        if (profile != null) {
          profile.experience.add(newExperience);
        }
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> removeExperienceRequest(String experienceID) async {
    setAdding(true);

    ProfileRequest().removeExperienceRequest(experienceID).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        fetchProfile("");
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> addRepositoryRequest(Repository repository) async {
    setAdding(true);

    ProfileRequest().addRepositoryRequest(repository).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        Repository newRepository = Repository.fromJson(json.decode(data.body));
        if (profile != null) {
          profile.repository.add(newRepository);
        }

        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> removeRepositoryRequest(String experienceID) async {
    setAdding(true);

    ProfileRequest().removeRepositoryRequest(experienceID).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        fetchProfile("");
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> addSkillRequest(String skillName) async {
    setAdding(true);

    ProfileRequest().addSkillRequest(skillName).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        Skills newSkill = Skills.fromJson(json.decode(data.body));
        if (profile != null && newSkill != null) {
          profile.skills.add(newSkill);
        }
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> removeSkillRequest(String skillID) async {
    setAdding(true);

    ProfileRequest().removeSkillRequest(skillID).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        fetchProfile("");
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> postSocialRequest(SocialMedia social) async {
    setAdding(true);

    ProfileRequest().postSocialRequest(social).then((data) {
      if (data.statusCode == 201 || data.statusCode == 200) {
        setAdding(false);
        SocialMedia newSocial = SocialMedia.fromJson(json.decode(data.body));
        if (profile != null && newSocial != null) {
          profile.socialMedia = newSocial;
        }
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setAdding(value) {
    adding = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setProfile(value) {
    profile = value;
    notifyListeners();
  }

  Profile getProfile() {
    return profile;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isProfile() {
    return profile != null ? true : false;
  }
}
