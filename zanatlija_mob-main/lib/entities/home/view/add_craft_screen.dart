import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/entities/home/bloc/craft_cubit.dart';
import 'package:zanatlija_app/entities/login/bloc/user_bloc.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';
import 'package:zanatlija_app/utils/common_widgets.dart';
import 'package:zanatlija_app/utils/constants.dart';

@RoutePage()
class AddCraft extends StatefulWidget {
  const AddCraft({super.key});

  @override
  State<AddCraft> createState() => _AddCraftState();
}

class _AddCraftState extends State<AddCraft> with AppMixin {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CraftCubit, CraftState>(
        listener: (context, state) {
          if (state is CraftLoadingState) {
          } else if (state is CraftStateError) {
            showSnackbarWithTitle(state.error, context);
          } else if (state is CrafAddNewJobSuccess ||
              state is CrafDeleteStateSuccess) {
            AutoRouter.of(context).maybePop();
            BlocProvider.of<CraftCubit>(context).getCraftListFromDatabase(
                BlocProvider.of<UserBloc>(context).state.user!);
            hideLoading(context);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Dodaj zanat',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  CommonTextField('Ime zanata', _nameController),
                              CommonTextField(
                                'Kategorija zanata',
                                _categoriesController,
                                keyboardType: TextInputType.none,
                                locations: categories,
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
                                'Cena po satu',
                                _priceController,
                                keyboardType: TextInputType.number,
                                isPriceText: true,
                              ),
                              CommonTextField(
                                'Opis zanata',
                                _descriptionController,
                                keyboardType: TextInputType.text,
                                isRichText: true,
                              ),
                              CommonTextField(
                                'Dodaj sliku',
                                _imageController,
                                keyboardType: TextInputType.none,
                                isImagePicker: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonActionButton(
                        onAction: () async {
                          final user =
                              BlocProvider.of<UserBloc>(context).state.user;
                          final craftCubit =
                              BlocProvider.of<CraftCubit>(context);
                          final File imageFile = File(_imageController.text);

                          final imageUrl =
                              await craftCubit.uploadAndGetImageUrl(imageFile);

                          final username = user?.nameSurname;
                          final randomRate = Random();
                          final randomDouble = 1 + randomRate.nextDouble() * 4;
                          final craft = Craft(
                            userId: user!.phoneNumber,
                            craftsmanName: username ?? '',
                            craftName: _categoriesController.text,
                            description: _descriptionController.text,
                            location: _locationController.text,
                            price: int.parse(_priceController.text),
                            imageUrl: imageUrl,
                            rate: randomDouble,
                          );
                          showLoading(context);
                          craftCubit.addNewJob(craft, user);
                        },
                        title: 'Dodaj',
                        customColor: const Color(0xff2B2727),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
