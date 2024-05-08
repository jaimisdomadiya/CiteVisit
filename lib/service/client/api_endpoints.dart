class ApiEndPoints {
  ApiEndPoints._();

  static String signIn = "api/bussiness-user/signin";
  static String socialSignIn = "api/bussiness-user/social-signin";
  static String signUp = "api/bussiness-user/signup";
  static String sendOtp = "api/bussiness-user/send-otp";
  static String verifyOtp = "api/bussiness-user/verify-otp";
  static String forgotPassword = "api/bussiness-user/forgot-password";
  static String verifyOtpEmail = "api/bussiness-user/verify-otp-email";
  static String createNewPassword = "api/bussiness-user/verify-otp-email";
  static String changePassword = "api/bussiness-user/change-password";
  static String updatePassword = "api/bussiness-user/update-password";
  static String updatePersonalDetail =
      "api/bussiness-user/update-personal-details";
  static String home = "api/project/get-projects?search=";
  static String getProfile = "api/bussiness-user/get-profile";
  static String addProject = "api/project/add-project";
  static String uploadImage = "api/admins/upload-img";
  static String sendRequest = "api/support/send-request";
  static String termsAndConditions = "api/get-terms-and-condition";
  static String addMember = "api/employee/add-member";
  static String getArea = "api/site/get-area";
  static String addArea = "api/site/add-area";
  static String addSite = "api/site/add-site";
  static String businessUserProfile = "api/bussiness-user/update-profile";
  static String getSites = "api/site/get-sites";
  static String getEmployee = "api/site/get-employees";
  static String deleteSite = "api/site/delete-site";
  static String deleteEmployee = "api/site/delete-employee";
  static String getSiteDetails = "api/site/get-site-detail";
  static String deleteArea = "api/site/delete-area";
  static String addAreaForSite = "api/site/add-areas-for-site";
  static String addFloorForSite = "api/site/add-floor";
  static String deleteFloorForSite = "api/site/delete-floor";
  static String addIndividualFloorImage =
      "api/site/add-add-individual-floor-image";
  static String deleteFloorImage = "api/site/delete-floorimg";
  static String updateIndividualFloorImage =
      "api/site/update-individual-floor-image";
  static String projectWiseSiteData = "api/site/get-site&employeewithprojectid";
  static String addComment = "api/comment/add-comment";
  static String addSubComment = "api/subcomment/add-comment";
  static String getComment = "api/comment/get-comment";
  static String notification = "api/notification/get-notification";
  static String logOut = "api/project/log-out";
  static String addMemberWithSite = "api/site/add-members-and-sites";
}
