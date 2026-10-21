import 'package:evently_c20_online/core/constante/app_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../manager/event_manager.dart';

import 'edit_event.dart';


class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var provider =Provider.of<EventProvider >(context );
    var event =provider .selectedEvent ;
    if(event ==null){
      return Scaffold(
        appBar: AppBar(title: Text("Event Details")) ,
        body:Center(child: Text ("No event selected"),) ,
      );
    }
    var category =AppCategory .categories .firstWhere( (c)=>c.id==event .categoryId,
    orElse: ()=>AppCategory.categories .first ,);
    DateTime ? eventDate = DateTime.tryParse( event .date );


    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        centerTitle: true,
        actions: [

          IconButton(
            icon: Icon(Icons.edit, color: theme.primaryColor),
            onPressed: () {
              var provider = Provider.of<EventProvider>(context, listen: false);
              if (provider.selectedEvent != null) {
                provider.initEditEvent(provider.selectedEvent!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditEventScreen(),
                  ),
                );
              }
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          final event = provider.selectedEvent;

          if (event == null) {
            return const Center(child: Text("No Event Details Available"));
          }


          var category = AppCategory.categories.firstWhere(
            (c) => c.id == event.categoryId,
            orElse: () => AppCategory.categories.first,
          );

          DateTime? eventDate = DateTime.tryParse(event.date);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? pickedData =await showDatePicker(context:  context ,
                        initialDate:eventDate ?? DateTime.now() ,
                        firstDate: DateTime( 2020), lastDate: DateTime( 2030));
                  },
                  child:

                    Center(
                      child: Text(
                        category.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ),
                    const SizedBox(height: 24),

                    // العنوان
                    Text(
                      event.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),


                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, color: theme.primaryColor),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eventDate != null
                                      ? DateFormat('dd MMMM yyyy').format(eventDate)
                                      : event.date,
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  event.time,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Description",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.desc,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),



              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<EventProvider>(
                context,
                listen: false,
              ).deleteEvent(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
