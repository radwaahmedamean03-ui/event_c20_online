import 'package:evently_c20_online/core/constante/app_category.dart';
import 'package:evently_c20_online/core/models/event_model.dart';
import 'package:evently_c20_online/core/services/db_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  int index = 0;

  AppCategory selectedCategory = AppCategory.categories.first;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime? selectedDateTime;
EventModel ? selectedEvent;
  TimeOfDay? selectedTime;

  void changeIndex(int value) {
    index = value;
    selectedCategory = AppCategory.categories[index];
    notifyListeners();
  }

  void changeDate(DateTime date) {
    selectedDateTime = date;
    notifyListeners();
  }

  void changeTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isLoading = false;

  void addEvent(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await DbService.addEvent(
      EventModel(
        id: "",
        categoryId: selectedCategory.id,
        date: selectedDateTime.toString(),
        desc: descController.text,
        time: selectedTime!.format(context),
        title: titleController.text,
      ),
    );
    isLoading = false;
    notifyListeners();
    Navigator.pop(context);
  }



  void setSelectedEvent(EventModel event) {
    selectedEvent = event;
    notifyListeners();
  }


  void initEditEvent(EventModel event) {
    selectedEvent = event;
    titleController.text = event.title;
    descController.text = event.desc;
    try {
      selectedDateTime = DateTime.parse(event.date);
    } catch (_) {
      selectedDateTime = DateTime.now();
    }

    int catIndex = AppCategory.categories.indexWhere((c) => c.id == event.categoryId);
    if (catIndex != -1) {
      index = catIndex;
      selectedCategory = AppCategory.categories[catIndex];
    }
    notifyListeners();
  }


  void updateEvent(BuildContext context) async {
    if (selectedEvent == null) return;

    isLoading = true;
    notifyListeners();

    EventModel updatedModel = EventModel(
      id: selectedEvent!.id,
      categoryId: selectedCategory.id,
      date: selectedDateTime.toString(),
      desc: descController.text,
      time: selectedTime != null ? selectedTime!.format(context) : selectedEvent!.time,
      title: titleController.text,
    );


    await DbService.updateEvent(updatedModel);

    selectedEvent = updatedModel;
    isLoading = false;
    notifyListeners();

    Navigator.pop(context);
  }


  void deleteEvent(BuildContext context) async {
    if (selectedEvent == null) return;

    isLoading = true;
    notifyListeners();

    await DbService.deleteEvent(selectedEvent!.id);

    isLoading = false;
    notifyListeners();

    Navigator.pop(context);
  }

}
