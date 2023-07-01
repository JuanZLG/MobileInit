import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'inicio.dart';

class Verificar extends StatelessWidget {
  const Verificar({Key? key});

  static const String _title = 'Verificación de Email';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _correoElectronicoController =
      TextEditingController();

  Future<void> _sendVerificationEmail() async {
    String username = 'brutalitysmell@gmail.com';
    String password = 'rbvixewlhulhzosj';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Brutality Supplements')
      ..recipients.add(_correoElectronicoController.text)
      ..subject = 'Correo Verificado ${DateTime.now()}'
      ..text =
          'Si estás viendo este correo electrónico, significa que tu correo ha sido verificado.'
      ..html = "No repliques este mensaje, gracias.";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      _showSnackBar('Correo electrónico enviado correctamente.');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      _showSnackBar('Error al enviar el correo electrónico.');
    }

    var connection = PersistentConnection(smtpServer);

    await connection.send(message);
    await connection.close();
  }

  void _validateEmailSent() {
    String username = 'brutalitysmell@gmail.com';
    String emailAddress = _correoElectronicoController.text;

    bool emailSent = verificarSiCorreoEnviado(username, emailAddress);

    if (emailSent) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage()), // Reemplaza "OtraRuta" con el nombre de la ruta que desees
      );
    } else {
      _showSnackBar('Correo electrónico no enviado. Verifica la dirección.');
    }
  }

  bool verificarSiCorreoEnviado(String username, String emailAddress) {
    // Lógica para verificar si el correo electrónico ha sido enviado a la dirección especificada
    // Aquí puedes implementar tu propia lógica de verificación, como consultar una base de datos o realizar una llamada a una API de validación de correo electrónico.

    // Por ahora, simularemos el envío exitoso de correo electrónico si la dirección de correo es igual a "example@example.com"
    return emailAddress == _correoElectronicoController.text;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  return Scaffold(
    body: Center(
      child: FractionallySizedBox(
        widthFactor: 0.8, // Ajusta el ancho según tus preferencias
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 30),
              const Text('Ingresa tu correo para que te enviemos un mensaje de confirmación.', style:TextStyle(color:Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _correoElectronicoController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: style,
                onPressed: _sendVerificationEmail,
                child: const Text('Confirmar Compra'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  );
}
}