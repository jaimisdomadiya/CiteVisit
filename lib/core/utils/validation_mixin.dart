part of 'utils.dart';

mixin ValidationMixin {
  String? emailValidator(String? email) {
    if (email?.trim().isNotEmpty ?? false) {
      if (_isEmailValid(email)) {
        return null;
      } else {
        return 'Enter valid email address';
      }
    } else {
      return 'Please enter email address';
    }
  }

  String? passwordValidator(String? password) {
    if (password?.trim().isNotEmpty ?? false) {
      if(password!.length < 6) {
        return 'Password should be a minimum 6 character';
      } else {
        return null;
      }
    } else {
      return 'Please enter your password';
    }
  }

  String? businessNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter business name';
    }
  }

  String? managerNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter manager name';
    }
  }

  String? firstNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter first name';
    }
  }

  String? lastNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter last name';
    }
  }

  String? phoneValidator(String? phone) {
    if (phone?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter phone no';
    }
  }

  String? confirmPasswordValidator(String? value, String password) {
    if (value?.trim().isNotEmpty ?? false) {
      if (password == value) {
        return null;
      }
      return 'Password dose not match.';
    } else {
      return 'Please re-enter your password.';
    }
  }

  String? nameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter name';
    }
  }

  String? floorNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter floor name';
    }
  }

  String? projectNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter project name';
    }
  }

  String? memberRoleValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please select member role';
    }
  }

  String? siteNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter site name';
    }
  }

  String? siteAddressValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter site address';
    }
  }

  String? siteValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please select site';
    }
  }

  String? membersValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please select member';
    }
  }

  String? areaBuildingNameValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter area/building name';
    }
  }

  String? inquiryValidator(String? name) {
    if (name?.trim().isNotEmpty ?? false) {
      return null;
    } else {
      return 'Please enter text';
    }
  }

  bool _isEmailValid(String? email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return email != null ? regex.hasMatch(email) : false;
  }
}
