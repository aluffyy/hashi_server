import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../prisma/generated_dart_client/client.dart';
import '../../prisma/generated_dart_client/prisma.dart';

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
  final name = json['name'] as String?;
  final lastname = json['lastname'] as String?;

  if (name == null || lastname == null) {
    return Response.json(body: {
      'message': 'Name and Lastname are required',
    }, statusCode: HttpStatus.badRequest);
  }

  final prisma = PrismaClient(
    datasources: Datasources(
        db: "mysql://root:123456@localhost:3306/mydb?schema=public"),
  );
  final user = await prisma.user.create(
    data: UserCreateInput(name: name, lastname: lastname),
  );
  return Response.json(
    body: {
      'message': 'Saved!',
      'user': user,
    },
  );
}
