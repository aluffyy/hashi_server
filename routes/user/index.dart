import 'dart:async';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUsers(),
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(body: 'This is default'))
  };
}

Future<Response> _getUsers() {
  return Future.value(
    Response.json(
      body: [
        {'name': 'mustakim', 'lastname': 'Islam'},
        {'name': 'muhtadee', 'lastname': 'taron'},
      ],
    ),
  );
}

Future<Response> _createUser(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final name = json['name'];
  final lastname = json['lastname'];
  return Response.json(
    body: {
      'message': 'Saved!',
      'user': {
        'name': name,
        'lastname': lastname,
      },
    },
  );
}
