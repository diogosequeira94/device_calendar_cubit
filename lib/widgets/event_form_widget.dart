import 'package:flutter/material.dart';

class EventFormWidget extends StatelessWidget {

  final Function (String eventName, String eventDescription) getEventData;

  EventFormWidget(this.getEventData);

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 5.0),
                    ),
                    labelText: 'Event Name'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: eventDescriptionController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 5.0),
                    ),
                    labelText: 'Event description'
                ),
                maxLines: 3,
                maxLength: 250,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.deepOrange,
                  onPressed: () {
                getEventData(eventNameController.text, eventDescriptionController.text);
              }, child: Text('Create Event', style: TextStyle(color: Colors.white),)),
            ),
          ],
        ),
      ),
    );
  }
}
