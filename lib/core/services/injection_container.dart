import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safenest/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:safenest/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';
import 'package:safenest/features/auth/domain/usecase/forgot_password.dart';
import 'package:safenest/features/auth/domain/usecase/logout.dart';
import 'package:safenest/features/auth/domain/usecase/sign_in.dart';
import 'package:safenest/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:safenest/features/auth/domain/usecase/sign_up.dart';
import 'package:safenest/features/auth/domain/usecase/update_user.dart';
import 'package:safenest/features/auth/domain/usecase/verify_email.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_remote_data.dart';
import 'package:safenest/features/digital_wellbeing/data/repository/digital_wellbeing_repo_imp.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';
import 'package:safenest/features/language/data/data_sources/language_local_data_source.dart';
import 'package:safenest/features/language/data/repository/language_repo_impl.dart';
import 'package:safenest/features/language/domain/repos/language_repository.dart';
import 'package:safenest/features/language/domain/usecases/get_language.dart';
import 'package:safenest/features/language/domain/usecases/set_language.dart';
import 'package:safenest/features/language/presentation/bloc/language_bloc.dart';
import 'package:safenest/features/profile/data/data_sources/parental_info_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:safenest/features/on_boarding/data/datasources/on_boarding_local_datasource.dart';
import 'package:safenest/features/on_boarding/data/repositories/on_boarding_repo_impl.dart';
import 'package:safenest/features/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:safenest/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:safenest/features/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:safenest/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

import 'package:safenest/features/auth/domain/usecase/sign_in_with_facebook.dart';
import 'package:safenest/features/profile/data/repositories/parental_info_repo_impl.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';
import 'package:safenest/features/profile/domain/usecase/add_child_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/get_paternal_info.dart';
import 'package:safenest/features/profile/domain/usecase/save_parental_info.dart';
import 'package:safenest/features/profile/domain/usecase/update_child_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/remove_child_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/set_pin_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/link_child_to_parent.dart';
import 'package:safenest/features/profile/domain/usecase/update_paternal_info.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';

// digital well being
import 'package:safenest/features/digital_wellbeing/domain/usecases/get_digital_wellbeing_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/update_digital_wellbeing_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/set_usage_limit_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/remove_usage_limit_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/get_digital_wellbeing_history_use_case.dart';
import 'package:safenest/features/digital_wellbeing/presentation/bloc/digital_wellbeing_bloc.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_local_data.dart';


// connecting devices
import 'package:safenest/features/connecting_devices/presentation/bloc/connection_bloc.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/accept_connection_request_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/get_pending_connection_requests_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/disconnect_devices_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/is_connected_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/reject_connection_request_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/send_connection_request.dart';

import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';
import 'package:safenest/features/connecting_devices/data/datasources/connection_remote_data_source.dart';
import 'package:safenest/features/connecting_devices/data/repositories/connection_repository_impl.dart';






part 'injection_container.main.dart';