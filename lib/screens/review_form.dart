import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:history_buddy/screens/historicalsite.dart';
import 'package:history_buddy/HistSite.dart';
import 'package:history_buddy/screens/reviews_page.dart';

class ReviewForm extends StatefulWidget {
  ReviewForm({required this.histsite});

  final HistSite histsite;

  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _reviewerController = TextEditingController();
  final _commentController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review ${widget.histsite.getName()}'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: _form(context),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          // Reviewer form field
          TextFormField(
            controller: _reviewerController,
            decoration: InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
            ),
            validator: (reviewer) {
              if(reviewer == null || reviewer.isEmpty) {
                return 'Reviewers name field cannot be empty';
              }
            },
          ),

          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: TextFormField(
              controller: _ratingController,
              decoration: InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
              validator: (rating) {
                if(rating == null || rating.isEmpty) {
                  return 'Rating field cannot be empty';
                }
                if(int.parse(rating) < 1) {
                  return 'Rating cannot be less than 1';
                }
                if(int.parse(rating) > 5) {
                  return 'Rating cannot be greater than 5';
                }
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
              maxLines: 4,
              validator: (comment) {
                if(comment == null || comment.isEmpty) return 'Comment field cannot be empty';
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: RaisedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {

                  CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

                  reviews
                        .add({
                      'hist_site': widget.histsite.getName(), // John Doe
                      'reviewer': _reviewerController.text,
                      'rating': int.parse(_ratingController.text),
                      'comment': _commentController.text,
                    });

                  Navigator.pop(context);
                }
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Submit'),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.send),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}