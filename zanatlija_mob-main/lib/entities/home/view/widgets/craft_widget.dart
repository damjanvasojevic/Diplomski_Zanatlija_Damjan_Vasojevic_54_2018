import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zanatlija_app/data/models/craft.dart';
import 'package:zanatlija_app/entities/home/bloc/chat_bloc.dart';
import 'package:zanatlija_app/navigation/router.gr.dart';
import 'package:zanatlija_app/utils/app_mixin.dart';

class CraftWidget extends StatefulWidget {
  final bool? fullSize;
  final bool? isMyJob;
  final Craft craft;
  final Function(String)? onChatCreated;
  const CraftWidget(this.craft,
      {this.fullSize, this.onChatCreated, this.isMyJob, super.key});

  @override
  State<CraftWidget> createState() => _CraftWidgetState();
}

class _CraftWidgetState extends State<CraftWidget> with AppMixin {
  @override
  Widget build(BuildContext context) {
    final containerHeight = widget.fullSize == true
        ? MediaQuery.of(context).size.height * 0.25
        : MediaQuery.of(context).size.height * 0.235;
    final containerWidth = widget.fullSize == true
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.635;

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is GetByIdSuccess) {
        } else if (state is GetByIdError) {
          showSnackbarWithTitle(state.error, context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          height: containerHeight,
          width: containerWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isMyJob == true
                                      ? Colors.white
                                      : Theme.of(context).primaryColorLight,
                                  border: Border.all(
                                    width: 1,
                                  )),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    widget.fullSize == true ? 14 : 10.0),
                                child: Text(widget.craft.craftsmanName[0]),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: containerWidth / 1.75,
                                    child: Text(
                                      widget.craft.craftName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: widget.fullSize == true
                                            ? 20.5
                                            : 17.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.craft.craftsmanName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff888888),
                                    fontSize:
                                        widget.fullSize == true ? 17.5 : 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Cena po satu:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff888888),
                                    fontSize: widget.fullSize == true ? 16 : 15,
                                  ),
                                ),
                                Text(
                                  "${widget.craft.price} €",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff292929),
                                    fontSize:
                                        widget.fullSize == true ? 30.5 : 29,
                                  ),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              width: 20,
                              color: Color(0xff888888),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lokacija:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff888888),
                                    fontSize: widget.fullSize == true ? 16 : 15,
                                  ),
                                ),
                                Text(
                                  widget.craft.location,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff292929),
                                    fontSize: widget.fullSize == true ? 16 : 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/hammerWrench.png',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.fullSize == true
                                  ? 'Skor: ${widget.craft.rate?.toStringAsFixed(1) ?? 0.0}/5'
                                  : '${widget.craft.rate?.toStringAsFixed(1) ?? 0.0}/5',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: widget.fullSize == true ? 25 : 29,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  alignment: const AlignmentDirectional(1.05, -1.05),
                  decoration: BoxDecoration(
                      border: const Border(
                        left: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                      ),
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            40,
                          ),
                          topRight: Radius.circular(0))),
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: InkWell(
                    onTap: () async {
                      AutoRouter.of(context).push(
                        ViewCraft(
                          craft: widget.craft,
                          isMyJob: widget.isMyJob,
                        ),
                      );
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
