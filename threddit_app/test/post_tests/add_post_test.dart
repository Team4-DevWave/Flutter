import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/post/view/add_post_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/post/view/widgets/add_poll.dart';

void main(){
  group("Check adding/removing image/video/link/poll", () { 
    test("Check link is true", () {
      //Asert
      bool isLink = addLink(true);

      expect(true, isLink);
    });

     test("Check link is false", () {
      //Asert
      bool isLink = removeLink(false);

      expect(false, isLink);
    });

    test("Check poll is true", () {
      //Asert
      bool isPoll = addPoll(true);

      expect(true, isPoll);
    });

     test("Check poll is false", () {
      //Asert
      bool isPoll = removePoll(false);

      expect(false, isPoll);
    });

    test("Check image is false", () {
      //Asert
      bool isImage = removeImage("", false);

      expect(true, isImage);
    });

     test("Check video is false", () {
      //Asert
      bool isVideo = removeVideo("",false);

      expect(true, isVideo);
    });

  });

  test("check when the link is valid", () {
    //Asert
    bool isValid = validateLink("https://www.google.com");

    expect(true, isValid);
  });

  test("check when the link is invalid", () {
    //Asert
    bool isValid = validateLink("i am an invalid link");

    expect(false, isValid);
  });

  group("adding a poll choice", () {
    test("Doesn't add more than 6 choices", () {
    //Arrange
    Map<String,dynamic> poll = {'option1': 'Choice 1', 'option2': 'Choice 2', 'option3': 'Choice 3', 'option4': 'Choice 4', 'option5': 'Choice 5', 'option6': 'Choice 6'};
    List<String> choices =['Choice 1', 'Choice 2', 'Choice 3', 'Choice 4', 'Choice 5', 'Choice 6'];
    List<TextEditingController> choiceControllers = List.generate(6, (index) => TextEditingController(text: 'Choice ${index + 1}'));

    //Act
    bool isAdded = addPollChoice(choiceControllers, 6, choices, poll);

    //Assert
    expect(false, isAdded);
    });
    test("Can add a choice if the choices are less than 6", () {
       //Arrange
    Map<String,dynamic> poll = {'option1': 'Choice 1', 'option2': 'Choice 2', 'option3': 'Choice 3', 'option4': 'Choice 4'};
    List<String> choices =['Choice 1', 'Choice 2', 'Choice 3', 'Choice 4'];
    List<TextEditingController> choiceControllers = List.generate(4, (index) => TextEditingController(text: 'Choice ${index + 1}'));

    //Act
    bool isAdded = addPollChoice(choiceControllers, 4, choices, poll);

    //Assert
    expect(true, isAdded);
    });
  });

}