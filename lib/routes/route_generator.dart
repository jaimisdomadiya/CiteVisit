import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/screens/account/notification/view/notification_screen.dart';
import 'package:cityvisit/views/screens/account/personal_detail/controller/personal_detail_binding.dart';
import 'package:cityvisit/views/screens/account/personal_detail/view/personal_detail_screen.dart';
import 'package:cityvisit/views/screens/account/support_request/view/support_request_screen.dart';
import 'package:cityvisit/views/screens/account/terms_condition/view/terms_condition_screen.dart';
import 'package:cityvisit/views/screens/account/update_password/view/update_password_screen.dart';
import 'package:cityvisit/views/screens/add_employee/controller/add_employee_binding.dart';
import 'package:cityvisit/views/screens/add_employee/view/add_employee_screen.dart';
import 'package:cityvisit/views/screens/authentication/create_new_password/controller/create_password_binding.dart';
import 'package:cityvisit/views/screens/authentication/create_new_password/view/create_new_password.dart';
import 'package:cityvisit/views/screens/authentication/otp_verification/controller/otp_binding.dart';
import 'package:cityvisit/views/screens/authentication/otp_verification/view/otp_verification.dart';
import 'package:cityvisit/views/screens/authentication/reset_password/controller/reset_password_binding.dart';
import 'package:cityvisit/views/screens/authentication/reset_password/view/reset_password_screen.dart';
import 'package:cityvisit/views/screens/authentication/sign_in_screen/controller/sign_in_binding.dart';
import 'package:cityvisit/views/screens/authentication/sign_in_screen/view/sign_in_screen.dart';
import 'package:cityvisit/views/screens/authentication/sign_up_screen/controller/sign_up_binding.dart';
import 'package:cityvisit/views/screens/authentication/sign_up_screen/view/business_name_screen.dart';
import 'package:cityvisit/views/screens/authentication/sign_up_screen/view/sign_up_screen.dart';
import 'package:cityvisit/views/screens/bottom_menu/controller/bottom_menu_binding.dart';
import 'package:cityvisit/views/screens/bottom_menu/view/bottom_menu_bar.dart';
import 'package:cityvisit/views/screens/create_project/controller/create_project_binding.dart';
import 'package:cityvisit/views/screens/create_project/view/create_new_site.dart';
import 'package:cityvisit/views/screens/create_project/view/create_project_screen.dart';
import 'package:cityvisit/views/screens/photo/controller/photo_binding.dart';
import 'package:cityvisit/views/screens/photo/photo_screen.dart';
import 'package:cityvisit/views/screens/project_detail/controller/project_detail_binding.dart';
import 'package:cityvisit/views/screens/project_detail/view/project_detail_screen.dart';
import 'package:cityvisit/views/screens/site_detail/controller/site_detail_binding.dart';
import 'package:cityvisit/views/screens/site_detail/view/area_edit_screen.dart';
import 'package:cityvisit/views/screens/site_detail/view/edit_floor_screen.dart';
import 'package:cityvisit/views/screens/site_detail/view/edit_image_screen.dart';
import 'package:cityvisit/views/screens/site_detail/view/site_detail_screen.dart';
import 'package:cityvisit/views/screens/site_detail/view/site_detail_take_photo_screen.dart';
import 'package:cityvisit/views/screens/splash/splash_screen.dart';
import 'package:cityvisit/views/screens/take_photo/view/take_photo_screen.dart';
import 'package:get/get.dart';

class GetPages {
  GetPages._();

  static List<GetPage> getPages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => const SignInScreen(),
      binding: SignInBind(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBind(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpVerificationScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.bottomMenu,
      page: () => const BottomMenuScreen(),
      binding: BottomMenuBind(),
    ),
    GetPage(
        name: Routes.projectDetail,
        page: () => const ProjectDetailScreen(),
        binding: ProjectDetailBind()),
    GetPage(
      name: Routes.siteDetail,
      page: () => const SiteDetailScreen(),
      binding: SiteDetailBind(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.createNewPassword,
      page: () => const CreateNewPassword(),
      binding: CreatePasswordBinding(),
    ),
    GetPage(
        name: Routes.addEmployee,
        page: () => const AddEmployeeScreen(),
        binding: AddEmployeeBind()),
    GetPage(
        name: Routes.takePhoto,
        page: () => const TakePhotoScreen(),
        binding: CreateProjectBind()),
    GetPage(
        name: Routes.photo,
        page: () => const PhotoScreen(),
        bindings: [PhotoBind(), SiteDetailBind()]),
    GetPage(
      name: Routes.personalDetail,
      page: () => const PersonalDetailScreen(),
      binding: PersonalBind(),
    ),
    GetPage(
      name: Routes.termsCondition,
      page: () => const TermsAndCondition(),
      binding: PersonalBind(),
    ),
    GetPage(
      name: Routes.supportRequest,
      page: () => const SupportRequestScreen(),
      binding: PersonalBind(),
    ),
    GetPage(
        name: Routes.createProject,
        page: () => const CreateProjectScreen(),
        binding: CreateProjectBind()),
    GetPage(
        name: Routes.createNewSite,
        page: () => const CreateNewSite(),
        binding: CreateProjectBind()),
    GetPage(
        name: Routes.businessName,
        page: () => const BusinessNameScreen(),
        binding: SignUpBind()),
    GetPage(
        name: Routes.editArea,
        page: () => const AreaEditScreen(),
        binding: SiteDetailBind()),
    GetPage(
        name: Routes.editFloor,
        page: () => const EditFloorScreen(),
        binding: SiteDetailBind()),
    GetPage(
        name: Routes.editPhoto,
        page: () => const EditImageScreen(),
        binding: SiteDetailBind()),
    GetPage(
        name: Routes.siteDetailsTakePhoto,
        page: () => const SiteDetailsTakePhoto(),
        binding: SiteDetailBind()),
    GetPage(
        name: Routes.updatePassword,
        page: () => const UpdatePasswordScreen(),
        binding: PersonalBind()),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationScreen(),
      binding: PersonalBind(),
    ),
  ];
}
