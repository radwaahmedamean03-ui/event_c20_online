import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../manager/event_manager.dart';

class EditEventScreen extends StatelessWidget {
  const EditEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var provider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextFormField(
              controller: provider.titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),


            SizedBox(
              height: 140,
              child: TextFormField(
                controller: provider.descController,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),


            Row(
              children: [
                Icon(Icons.date_range, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text("Event Date", style: theme.textTheme.titleLarge),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: provider.selectedDateTime ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then((value) {
                      if (value != null) {
                        provider.changeDate(value);
                      }
                    });
                  },
                  child: Text(
                    provider.selectedDateTime == null
                        ? "Choose Date"
                        : DateFormat.yMd().format(provider.selectedDateTime!),
                    style: theme.textTheme.titleMedium!.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.timelapse_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text("Event Time", style: theme.textTheme.titleLarge),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      if (value != null) {
                        provider.changeTime(value);
                      }
                    });
                  },
                  child: Text(
                    provider.selectedTime == null
                        ? "Choose Time"
                        : provider.selectedTime!.format(context),
                    style: theme.textTheme.titleMedium!.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  provider.updateEvent(context);
                },
                child: provider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("Update Event"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
