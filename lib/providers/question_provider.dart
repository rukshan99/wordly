// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wordly/controllers/question_controller.dart';
import 'package:wordly/models/question.dart';

class QuestionProvider with ChangeNotifier {
  // data members
  final controller = QuestionController();
  RxInt _questionNumber = 1.obs;
  PageController _pageController = PageController();
  List<int> _selectedOptions = [];
  int _correctAnswers = 0;

  // getters
  Stream<List<Question>> get questions => controller.getQuesions();
  RxInt get questionNumber => _questionNumber;
  PageController get pageController => _pageController;
  List<int> get selectedOptions => _selectedOptions;
  int get correctAnswers => _correctAnswers;

  // update question number
  void upateQuesionNumber(int index) {
    _questionNumber.value = index + 1;
  }

  // select answer
  void lockAnswer(int index) {
    _selectedOptions.add(index);
  }

  // check answer
  void checkAnswer(Question question) {
    var tempList = [];
    var noOfCorrectlyIdentified = 0;

    for (int i = 0; i < question.answers.length; i++) {
      if (question.answers[i] == true) {
        tempList.add(i);
      }
    }

    if (_selectedOptions.length == tempList.length) {
      for (int j = 0; j < _selectedOptions.length; j++) {
        for (int k = 0; k < tempList.length; k++) {
          if (tempList[k] == _selectedOptions[j]) {
            noOfCorrectlyIdentified++;
          }
        }
      }
    }

    if (noOfCorrectlyIdentified == tempList.length) {
      _correctAnswers++;
    }

    _selectedOptions.clear();
  }

  // move to next question
  void nextQuestion() {
    if (_questionNumber.value != questions.length) {
      _pageController.nextPage(
          duration: const Duration(microseconds: 250), curve: Curves.ease);
    }
  }
}
