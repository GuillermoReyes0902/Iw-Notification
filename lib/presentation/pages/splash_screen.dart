import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/presentation/pages/notification_list_screen.dart';
import 'package:iwproject/presentation/pages/user_login_screen.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const int durationPulse = 2;
  static const int durationPulseAfterNavigate = 3;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
    super.initState();
  }

  ///Función que dispara el proceso de animaciones visuales y consulta de información de sesión
  _getData() async {
    final controller = context.read<NotificationProvider>();
    //Cargar usuarios desde Firestore
    await controller.getUsers();
    //Cargar proyectos desde Firestore
    await controller.getProjects();
    //Verificar si hay un usuario en sesión
    await controller.getUser().then((user) {
      if (user != null) {
        //Navegar a la pantalla principal
        _goToPage(const NotificationListScreen());
      } else {
        //Navegar a la pantalla de login
        _goToPage(const UserLoginScreen());
      }
    });
  }

  ///Método que se encarga de la navegación automática iniciada desde la splash screen
  _goToPage(Widget nextPage) async {
    await Future.delayed(
      const Duration(seconds: durationPulseAfterNavigate),
    ).then((value) async {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pulse(
              duration: const Duration(seconds: durationPulse),
              infinite: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("assets/icon.png", height: 125, width: 125),
              ),
            ),
            SizedBox(height: 45),
            Text(
              "Cargando datos...",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
