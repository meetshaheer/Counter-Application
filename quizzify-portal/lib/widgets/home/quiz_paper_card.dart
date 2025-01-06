import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_separator/easy_separator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzle/configs/configs.dart';
import 'package:quizzle/controllers/controllers.dart';
import 'package:quizzle/controllers/quiz_paper/quiz_papers_controller.dart';
import 'package:quizzle/models/quiz_paper_model.dart';
import 'package:quizzle/screens/screens.dart';
import 'package:quizzle/widgets/widgets.dart';

// class QuizPaperCard extends GetView<QuizPaperController> {
//   const QuizPaperCard({Key? key, required this.model}) : super(key: key);

//   final QuizPaperModel model;

//   @override
//   Widget build(BuildContext context) {
//     const double _padding = 10.0;
//     return Ink(
//       decoration: BoxDecoration(
//         borderRadius: UIParameters.cardBorderRadius,
//         color: Theme.of(context).cardColor,
//       ),
//       child: InkWell(
//         borderRadius: UIParameters.cardBorderRadius,
//         onTap: () {
//           controller.navigatoQuestions(paper: model);
//         },
//         child: Padding(
//             padding: const EdgeInsets.all(_padding),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Expanded(
//                         child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           model.title,
//                           style: cardTitleTs(context).copyWith(
//                             color: Color.fromARGB(255, 30, 224, 195),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10, bottom: 15),
//                           child: Text(model.description),
//                         ),
//                         FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: const Color.fromARGB(255, 168, 255, 255),
//                             ),
//                             child: EasySeparatedRow(
//                               separatorBuilder: (BuildContext context, int index) {
//                                 return const SizedBox(width: 15);
//                               },
//                               children: [
//                                 IconWithText(
//                                     icon: Icon(Icons.help_outline_sharp, color: Colors.blue[700]),
//                                     text: Text(
//                                       '${model.questionsCount} quizzes',
//                                       style: kDetailsTS.copyWith(color: Colors.blue[700]),
//                                     )),
//                                 IconWithText(
//                                     icon: const Icon(Icons.timer, color: Colors.blueGrey),
//                                     text: Text(
//                                       model.timeInMinits(),
//                                       style: kDetailsTS.copyWith(color: Colors.blueGrey),
//                                     )),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ))
//                   ],
//                 ),
//                 Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () {
//                         // Get.find<NotificationService>().showQuizCompletedNotification(id: 1, title: 'Sampole', body: 'Sample', imageUrl: model.imageUrl, payload: json.encode(model.toJson())  );
//                         Get.toNamed(LeaderBoardScreen.routeName, arguments: model);
//                       },
//                       child: Ink(
//                         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//                         child: const Icon(
//                           AppIcons.trophyoutline,
//                           color: Colors.black,
//                           weight: 20,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ))
//               ],
//             )),
//       ),
//     );
//   }
// }

class QuizPaperCard extends GetView<QuizPaperController> {
  const QuizPaperCard({Key? key, required this.model}) : super(key: key);

  final QuizPaperModel model;

  Future<bool> _isQuizCompleted(String quizId) async {
    User? user = Get.find<AuthController>().getUser();
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('myrecent_quizes')
        .doc(quizId)
        .get();

    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    const double _padding = 10.0;
    return Ink(
      decoration: BoxDecoration(
        borderRadius: UIParameters.cardBorderRadius,
        color: Theme.of(context).cardColor,
      ),
      child: FutureBuilder<bool>(
        future: _isQuizCompleted(model.id),
        builder: (context, snapshot) {
          bool isCompleted = snapshot.data ?? false;

          return InkWell(
            borderRadius: UIParameters.cardBorderRadius,
            onTap: isCompleted
                ? () {
                    Get.snackbar("Quiz Completed", "You cannot retake this quiz.",
                        snackPosition: SnackPosition.BOTTOM, colorText: Colors.black);
                  }
                : () {
                    controller.navigatoQuestions(paper: model);
                  },
            child: Padding(
                padding: const EdgeInsets.all(_padding),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.title,
                              style: cardTitleTs(context).copyWith(
                                color: isCompleted ? Colors.grey : Color.fromARGB(255, 30, 224, 195),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 15),
                              child: Text(model.description),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isCompleted
                                      ? Colors.grey.withOpacity(0.3)
                                      : const Color.fromARGB(255, 168, 255, 255),
                                ),
                                child: EasySeparatedRow(
                                  separatorBuilder: (BuildContext context, int index) {
                                    return const SizedBox(width: 15);
                                  },
                                  children: [
                                    IconWithText(
                                        icon: Icon(Icons.help_outline_sharp, color: Colors.blue[700]),
                                        text: Text(
                                          '${model.questionsCount} quizzes',
                                          style: kDetailsTS.copyWith(color: Colors.blue[700]),
                                        )),
                                    IconWithText(
                                        icon: const Icon(Icons.timer, color: Colors.blueGrey),
                                        text: Text(
                                          model.timeInMinits(),
                                          style: kDetailsTS.copyWith(color: Colors.blueGrey),
                                        )),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        // Get.find<NotificationService>().showQuizCompletedNotification(id: 1, title: 'Sampole', body: 'Sample', imageUrl: model.imageUrl, payload: json.encode(model.toJson())  );
                                        Get.toNamed(LeaderBoardScreen.routeName, arguments: model);
                                      },
                                      child: Ink(
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                                        child: const Icon(
                                          AppIcons.trophyoutline,
                                          color: Colors.black,
                                          weight: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color.fromARGB(255, 121, 253, 253),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
