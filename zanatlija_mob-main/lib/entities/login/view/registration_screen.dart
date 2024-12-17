import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/data/models/user.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';
import 'package:zanatlija_app/utils/common_widgets.dart';
import 'package:zanatlija_app/utils/constants.dart';
import 'package:zanatlija_app/utils/validator.dart';

@RoutePage()
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> with AppMixin {
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _nameSurnameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegistrationAction() {
    if (_nameSurnameController.text.isEmpty ||
        !isValidFullname(_nameSurnameController.text)) {
      showSnackbarWithTitle('Unesite validno ime i prezime', context);
      return;
    } else if (_dateController.text.isEmpty) {
      showSnackbarWithTitle('Unesite validan datum rodjenja', context);
      return;
    } else if (_locationController.text.isEmpty) {
      showSnackbarWithTitle('Izaberite validnu lokaciju', context);
      return;
    } else if (_emailController.text.isEmpty ||
        !isEmailValid(_emailController.text)) {
      showSnackbarWithTitle('Unesite validnu email adresu', context);
      return;
    } else if (_phoneController.text.isEmpty ||
        !isPhoneNumberValid(_phoneController.text)) {
      showSnackbarWithTitle('Unesite validan broj telefona', context);
      return;
    } else if (_passwordController.text.isEmpty) {
      showSnackbarWithTitle('Sifra ne sme biti prazna', context);
      return;
    } else if (_passwordController.text.length <= 5) {
      showSnackbarWithTitle('Sifra je prekratka', context);
      return;
    }
    // final imageUrl =
    //                           await craftCubit.uploadAndGetImageUrl(imageFile);
    final password = getHashedPassword(_passwordController.text);
    final user = User(
        nameSurname: _nameSurnameController.text,
        birthDateInMillis: DateFormat('dd/MM/yyyy')
            .parse(_dateController.text)
            .millisecondsSinceEpoch,
        email: _emailController.text,
        location: _locationController.text,
        password: password,
        phoneNumber: _phoneController.text);
    BlocProvider.of<UserBloc>(context).add(CreateUserEvent(user));
    AutoRouter.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Popuni profil',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 43),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonTextField('Ime i prezime', _nameSurnameController),
                    CommonTextField(
                      'Godina rodjenja',
                      _dateController,
                      isDatePicker: true,
                      disableCopyPaste: true,
                    ),
                    CommonTextField(
                      'Lokacija',
                      _locationController,
                      keyboardType: TextInputType.none,
                      locations: locations,
                      disableCopyPaste: true,
                    ),
                    CommonTextField(
                      'Email',
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CommonTextField(
                      'Broj telefona',
                      _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    CommonTextField(
                      'Šifra',
                      _passwordController,
                      obscureText: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonActionButton(
                  title: 'Registruj se',
                  onAction: _onRegistrationAction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
