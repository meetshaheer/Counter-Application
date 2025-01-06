// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class UploadTestPaper extends StatelessWidget {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   static const String routeName = '/home';

// //   final titleController = TextEditingController();
// //   final descriptionController = TextEditingController();
// //   final timeController = TextEditingController();
// //   final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Upload Test Paper')),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             TextField(
// //               controller: titleController,
// //               decoration: InputDecoration(labelText: 'Test Title'),
// //             ),
// //             TextField(
// //               controller: descriptionController,
// //               decoration: InputDecoration(labelText: 'Description'),
// //             ),
// //             TextField(
// //               controller: timeController,
// //               keyboardType: TextInputType.number,
// //               decoration: InputDecoration(labelText: 'Time (Seconds)'),
// //             ),
// //             SizedBox(height: 20),
// //             Obx(() => ListView.builder(
// //                   shrinkWrap: true,
// //                   itemCount: questions.length,
// //                   itemBuilder: (context, index) {
// //                     return QuestionForm(
// //                       questionIndex: index,
// //                       questionData: questions[index],
// //                       onRemove: () => questions.removeAt(index),
// //                       onChange: (updatedQuestion) => questions[index] = updatedQuestion,
// //                     );
// //                   },
// //                 )),
// //             SizedBox(height: 10),
// //             ElevatedButton(
// //               onPressed: () => questions.add({
// //                 'id': 'q${questions.length + 1}', // Generate unique ID
// //                 'question': '',
// //                 'correct_answer': 'A',
// //                 'answers': [
// //                   {'identifier': 'A', 'answer': ''},
// //                   {'identifier': 'B', 'answer': ''},
// //                   {'identifier': 'C', 'answer': ''},
// //                   {'identifier': 'D', 'answer': ''},
// //                 ],
// //               }),
// //               child: Text('Add Question'),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: uploadQuizToFirebase,
// //               child: Text('Upload Test Paper'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void uploadQuizToFirebase() async {
// //     final title = titleController.text.trim();
// //     final description = descriptionController.text.trim();
// //     final time = int.tryParse(timeController.text.trim()) ?? 0;

// //     if (title.isEmpty || description.isEmpty || time <= 0) {
// //       Get.snackbar('Error', 'Please fill all fields');
// //       return;
// //     }

// //     final quizId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID for quiz
// //     final quizData = {
// //       'id': quizId,
// //       'title': title,
// //       'image_url': '', // Add logic for image if needed
// //       'Description': description,
// //       'questions_count': questions.length,
// //       'time_seconds': time,
// //       'questions': questions.map((q) {
// //         return {
// //           'id': q['id'],
// //           'question': q['question'],
// //           'correct_answer': q['correct_answer'],
// //           'answers': q['answers'],
// //         };
// //       }).toList(),
// //     };

// //     try {
// //       // Add quiz to `quizpapers` collection
// //       await _firestore.collection('quizpapers').doc(quizId).set(quizData);

// //       // Add individual questions under a sub-collection
// //       for (var question in questions) {
// //         final questionId = question['id'];
// //         final questionData = {
// //           'question': question['question'],
// //           'correct_answer': question['correct_answer'],
// //           'answers': question['answers'],
// //         };

// //         await _firestore.collection('quizpapers').doc(quizId).collection('questions').doc(questionId).set(questionData);
// //       }

// //       Get.snackbar('Success', 'Test Paper uploaded successfully');
// //       clearFields();
// //     } catch (e) {
// //       Get.snackbar('Error', 'Failed to upload test paper: $e');
// //     }
// //   }

// //   void clearFields() {
// //     titleController.clear();
// //     descriptionController.clear();
// //     timeController.clear();
// //     questions.clear();
// //   }
// // }

// // class QuestionForm extends StatefulWidget {
// //   final int questionIndex;
// //   final Map<String, dynamic> questionData;
// //   final Function(Map<String, dynamic>) onChange;
// //   final VoidCallback onRemove;

// //   QuestionForm({
// //     required this.questionIndex,
// //     required this.questionData,
// //     required this.onChange,
// //     required this.onRemove,
// //   });

// //   @override
// //   _QuestionFormState createState() => _QuestionFormState();
// // }

// // class _QuestionFormState extends State<QuestionForm> {
// //   final _questionController = TextEditingController();
// //   final _answerControllers = List.generate(4, (_) => TextEditingController());
// //   String _correctAnswer = 'A';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _questionController.text = widget.questionData['question'];
// //     for (int i = 0; i < 4; i++) {
// //       _answerControllers[i].text = widget.questionData['answers'][i]['answer'];
// //     }
// //     _correctAnswer = widget.questionData['correct_answer'];
// //   }

// //   @override
// //   void dispose() {
// //     _questionController.dispose();
// //     for (var controller in _answerControllers) {
// //       controller.dispose();
// //     }
// //     super.dispose();
// //   }

// //   void updateQuestionData() {
// //     widget.onChange({
// //       'id': widget.questionData['id'],
// //       'question': _questionController.text,
// //       'correct_answer': _correctAnswer,
// //       'answers': _answerControllers.asMap().entries.map((entry) {
// //         final identifier = String.fromCharCode(65 + entry.key); // 'A', 'B', ...
// //         return {'identifier': identifier, 'answer': entry.value.text};
// //       }).toList(),
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.symmetric(vertical: 8.0),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _questionController,
// //               decoration: InputDecoration(labelText: 'Question'),
// //               onChanged: (value) => updateQuestionData(),
// //             ),
// //             for (int i = 0; i < 4; i++)
// //               TextField(
// //                 controller: _answerControllers[i],
// //                 decoration: InputDecoration(
// //                   labelText: 'Answer ${String.fromCharCode(65 + i)}',
// //                 ),
// //                 onChanged: (value) => updateQuestionData(),
// //               ),
// //             DropdownButton<String>(
// //               value: _correctAnswer,
// //               onChanged: (value) {
// //                 setState(() {
// //                   _correctAnswer = value!;
// //                   updateQuestionData();
// //                 });
// //               },
// //               items: ['A', 'B', 'C', 'D'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// //             ),
// //             TextButton(
// //               onPressed: widget.onRemove,
// //               child: Text('Remove Question'),
// //               style: TextButton.styleFrom(foregroundColor: Colors.red),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UploadTestPaper extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static const String routeName = '/home';

//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final timeController = TextEditingController();
//   final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Test Paper')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: InputDecoration(labelText: 'Test Title'),
//             ),
//             TextField(
//               controller: descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             TextField(
//               controller: timeController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Time (Seconds)'),
//             ),
//             SizedBox(height: 20),
//             Obx(() => ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: questions.length,
//                   itemBuilder: (context, index) {
//                     return QuestionForm(
//                       questionIndex: index,
//                       questionData: questions[index],
//                       onRemove: () => questions.removeAt(index),
//                       onChange: (updatedQuestion) => questions[index] = updatedQuestion,
//                     );
//                   },
//                 )),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => questions.add({
//                 'id': 'q${questions.length + 1}',
//                 'question': '',
//                 'correct_answer': 'A',
//                 'answers': [
//                   {'identifier': 'A', 'answer': ''},
//                   {'identifier': 'B', 'answer': ''},
//                   {'identifier': 'C', 'answer': ''},
//                   {'identifier': 'D', 'answer': ''},
//                 ],
//               }),
//               child: Text('Add Question'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadQuizToFirebase,
//               child: Text('Upload Test Paper'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void uploadQuizToFirebase() async {
//     final title = titleController.text.trim();
//     final description = descriptionController.text.trim();
//     final time = int.tryParse(timeController.text.trim()) ?? 0;

//     if (title.isEmpty || description.isEmpty || time <= 0) {
//       Get.snackbar('Error', 'Please fill all fields');
//       return;
//     }

//     final quizId = DateTime.now().millisecondsSinceEpoch.toString();
//     final quizData = {
//       'id': quizId,
//       'title': title,
//       'image_url': '',
//       'Description': description,
//       'questions_count': questions.length,
//       'time_seconds': time,
//       'questions': questions
//           .map((q) => {
//                 'id': q['id'],
//                 'question': q['question'],
//                 'correct_answer': q['correct_answer'],
//                 'answers': q['answers'],
//               })
//           .toList(),
//     };

//     try {
//       await _firestore.collection('quizpapers').doc(quizId).set(quizData);

//       for (var question in questions) {
//         final questionId = question['id'];
//         await _firestore.collection('quizpapers').doc(quizId).collection('questions').doc(questionId).set(question);
//       }

//       Get.snackbar('Success', 'Test Paper uploaded successfully');
//       clearFields();
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to upload test paper: $e');
//     }
//   }

//   void clearFields() {
//     titleController.clear();
//     descriptionController.clear();
//     timeController.clear();
//     questions.clear();
//   }
// }

// class QuestionForm extends StatefulWidget {
//   final int questionIndex;
//   final Map<String, dynamic> questionData;
//   final Function(Map<String, dynamic>) onChange;
//   final VoidCallback onRemove;

//   QuestionForm({
//     required this.questionIndex,
//     required this.questionData,
//     required this.onChange,
//     required this.onRemove,
//   });

//   @override
//   _QuestionFormState createState() => _QuestionFormState();
// }

// class _QuestionFormState extends State<QuestionForm> {
//   final _questionController = TextEditingController();
//   final _answerControllers = List.generate(4, (_) => TextEditingController());
//   String _correctAnswer = 'A';

//   @override
//   void initState() {
//     super.initState();
//     _questionController.text = widget.questionData['question'];
//     for (int i = 0; i < 4; i++) {
//       _answerControllers[i].text = widget.questionData['answers'][i]['answer'];
//     }
//     _correctAnswer = widget.questionData['correct_answer'];
//   }

//   @override
//   void dispose() {
//     _questionController.dispose();
//     for (var controller in _answerControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void updateQuestionData() {
//     widget.onChange({
//       'id': widget.questionData['id'],
//       'question': _questionController.text,
//       'correct_answer': _correctAnswer,
//       'answers': _answerControllers.asMap().entries.map((entry) {
//         final identifier = String.fromCharCode(65 + entry.key);
//         return {'identifier': identifier, 'answer': entry.value.text};
//       }).toList(),
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _questionController,
//               decoration: InputDecoration(labelText: 'Question'),
//               onChanged: (_) => updateQuestionData(),
//             ),
//             for (int i = 0; i < 4; i++)
//               TextField(
//                 controller: _answerControllers[i],
//                 decoration: InputDecoration(
//                   labelText: 'Answer ${String.fromCharCode(65 + i)}',
//                 ),
//                 onChanged: (_) => updateQuestionData(),
//               ),
//             DropdownButton<String>(
//               value: _correctAnswer,
//               onChanged: (value) {
//                 setState(() {
//                   _correctAnswer = value!;
//                   updateQuestionData();
//                 });
//               },
//               items: ['A', 'B', 'C', 'D'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//             ),
//             TextButton(
//               onPressed: widget.onRemove,
//               child: Text('Remove Question'),
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadTestPaper extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String routeName = '/home';

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeController = TextEditingController();
  final RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Test Paper')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Test Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Time (Seconds)'),
            ),
            SizedBox(height: 20),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return QuestionForm(
                      questionIndex: index,
                      questionData: questions[index],
                      onRemove: () => questions.removeAt(index),
                      onChange: (updatedQuestion) => questions[index] = updatedQuestion,
                    );
                  },
                )),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => questions.add({
                'id': 'q${questions.length + 1}',
                'question': '',
                'correct_answer': 'A',
                'answers': [
                  {'identifier': 'A', 'answer': ''},
                  {'identifier': 'B', 'answer': ''},
                  {'identifier': 'C', 'answer': ''},
                  {'identifier': 'D', 'answer': ''},
                ],
              }),
              child: Text('Add Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadQuizToFirebase,
              child: Text('Upload Test Paper'),
            ),
          ],
        ),
      ),
    );
  }

  // void uploadQuizToFirebase() async {
  //   final title = titleController.text.trim();
  //   final description = descriptionController.text.trim();
  //   final time = int.tryParse(timeController.text.trim()) ?? 0;

  //   if (title.isEmpty || description.isEmpty || time <= 0) {
  //     Get.snackbar('Error', 'Please fill all fields');
  //     return;
  //   }

  //   final quizId = DateTime.now().millisecondsSinceEpoch.toString();
  //   final quizData = {
  //     'id': quizId,
  //     'title': title,
  //     'image_url': '',
  //     'Description': description,
  //     'questions_count': questions.length,
  //     'time_seconds': time,
  //   };

  //   try {
  //     // Upload the quiz paper itself
  //     await _firestore.collection('quizpapers').doc(quizId).set(quizData);

  //     // Upload each question under its own path
  //     for (var question in questions) {
  //       final questionId = question['id'];
  //       final questionData = {
  //         'question': question['question'],
  //         'correct_answer': question['correct_answer'],
  //         'answers': question['answers']
  //       };
  //       for (var answer in question['answers']) {
  //         await _firestore
  //             .collection('quizpapers')
  //             .doc(quizId)
  //             .collection('questions')
  //             .doc(questionId)
  //             .collection('answers')
  //             .doc(answer['identifier'])
  //             .set({'answer': answer['answer']});
  //       }

  //       // Upload question data in the correct structure
  //       await _firestore.collection('quizpapers').doc(quizId).collection('questions').doc(questionId).set(questionData);
  //     }

  //     Get.snackbar('Success', 'Test Paper uploaded successfully');
  //     clearFields();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to upload test paper: $e');
  //   }
  // }
  void uploadQuizToFirebase() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final time = int.tryParse(timeController.text.trim()) ?? 0;

    if (title.isEmpty || description.isEmpty || time <= 0) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    final quizId = DateTime.now().millisecondsSinceEpoch.toString();
    final quizData = {
      'id': quizId,
      'title': title,
      'image_url': '',
      'Description': description,
      'questions_count': questions.length,
      'time_seconds': time,
    };

    try {
      // Upload the quiz paper itself
      await _firestore.collection('quizpapers').doc(quizId).set(quizData);

      // Upload each question under its own path
      for (var question in questions) {
        final questionId = question['id'];
        final questionData = {
          'question': question['question'],
          'correct_answer': question['correct_answer'],
        };

        // Upload the question data to the 'questions' collection
        await _firestore.collection('quizpapers').doc(quizId).collection('questions').doc(questionId).set(questionData);

        // Upload each answer for the current question
        for (var answer in question['answers']) {
          final answerId = answer['identifier'];
          await _firestore
              .collection('quizpapers')
              .doc(quizId)
              .collection('questions')
              .doc(questionId)
              .collection('answers')
              .doc(answerId)
              .set({
            'answer': answer['answer'],
            'identifier': answerId,
          });
        }
      }

      Get.snackbar('Success', 'Test Paper uploaded successfully');
      clearFields();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload test paper: $e');
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    timeController.clear();
    questions.clear();
  }
}

class QuestionForm extends StatefulWidget {
  final int questionIndex;
  final Map<String, dynamic> questionData;
  final Function(Map<String, dynamic>) onChange;
  final VoidCallback onRemove;

  QuestionForm({
    required this.questionIndex,
    required this.questionData,
    required this.onChange,
    required this.onRemove,
  });

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _questionController = TextEditingController();
  final _answerControllers = List.generate(4, (_) => TextEditingController());
  String _correctAnswer = 'A';

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.questionData['question'];
    for (int i = 0; i < 4; i++) {
      _answerControllers[i].text = widget.questionData['answers'][i]['answer'];
    }
    _correctAnswer = widget.questionData['correct_answer'];
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateQuestionData() {
    widget.onChange({
      'id': widget.questionData['id'],
      'question': _questionController.text,
      'correct_answer': _correctAnswer,
      'answers': _answerControllers.asMap().entries.map((entry) {
        final identifier = String.fromCharCode(65 + entry.key);
        return {'identifier': identifier, 'answer': entry.value.text};
      }).toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
              onChanged: (_) => updateQuestionData(),
            ),
            for (int i = 0; i < 4; i++)
              TextField(
                controller: _answerControllers[i],
                decoration: InputDecoration(
                  labelText: 'Answer ${String.fromCharCode(65 + i)}',
                ),
                onChanged: (_) => updateQuestionData(),
              ),
            DropdownButton<String>(
              value: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                  updateQuestionData();
                });
              },
              items: ['A', 'B', 'C', 'D'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
            TextButton(
              onPressed: widget.onRemove,
              child: Text('Remove Question'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
