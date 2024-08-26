import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safenest/core/common/app/providers/user_session.dart';
import 'package:safenest/core/common/network/custom_http_client.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safenest/features/on_boarding/data/datasources/on_boarding_local_datasource.dart';
import 'package:safenest/features/on_boarding/data/repositories/on_boarding_repo_impl.dart';
import 'package:safenest/features/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:safenest/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:safenest/features/on_boarding/domain/usecases/check_if_user_first_timer.dart';
import 'package:safenest/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

import '../../features/auth/domain/usecase/sign_in_with_facebook.dart';

part 'injection_container.main.dart';