import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quizzle/models/quiz_paper_model.dart';

class UploadTestController extends GetxController {
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;

  Future<void> uploadTestData({
    required String title,
    required String description,
    required int timeSeconds,
    required List<Map<String, dynamic>> questions,
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      isUploading.value = true;
      uploadProgress.value = 0.0;

      var batch = firestore.batch();
      String testId = firestore.collection('test_papers').doc().id;

      // Set test paper metadata
      batch.set(firestore.collection('test_papers').doc(testId), {
        "title": title,
        "description": description,
        "time_seconds": timeSeconds,
        "questions_count": questions.length,
      });

      // Set questions and answers
      for (int i = 0; i < questions.length; i++) {
        final question = questions[i];
        final questionId = firestore.collection('questions').doc().id;

        final questionPath = firestore
            .collection('test_papers')
            .doc(testId)
            .collection('questions')
            .doc(questionId);

        // Add question
        batch.set(questionPath, {
          "question": question['question'],
          "correct_answer": question['correct_answer'],
        });

        // Add answers
        List<Map<String, String>> answers =
            List<Map<String, String>>.from(question['answers']);
        for (var answer in answers) {
          batch.set(
              questionPath.collection('answers').doc(answer['identifier']), {
            "identifier": answer['identifier'],
            "answer": answer['answer'],
          });
        }

        // Update progress
        uploadProgress.value = (i + 1) / questions.length;
      }

      await batch.commit();
      Get.snackbar('Success', 'Test data uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload data: $e');
    } finally {
      isUploading.value = false;
    }
  }
}
