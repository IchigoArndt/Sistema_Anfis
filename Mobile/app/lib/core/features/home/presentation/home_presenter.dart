import 'package:flutter/material.dart';
import 'package:sistema_distribuido/core/features/avaliacoes/data/models/assessment_model.dart';
import 'package:sistema_distribuido/core/features/home/data/services/home_service.dart';
import 'package:sistema_distribuido/core/shared/di/service_locator.dart';
import 'package:sistema_distribuido/core/features/home/presentation/widgets/home_appbar.dart';
import 'package:sistema_distribuido/core/features/home/presentation/widgets/home_welcome_card.dart';
import 'package:sistema_distribuido/core/features/home/presentation/widgets/HomeMetricsRow.dart';
import 'package:sistema_distribuido/core/features/home/presentation/widgets/HomeQuickActions.dart';
import 'package:sistema_distribuido/core/features/home/presentation/widgets/HomeNextEvaluationFromAssessment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final HomeService _homeService = sl<HomeService>();

  late Future<({AssessmentModel? proxima, double? weight, double? imc})>
      _homeFuture;

  @override
  void initState() {
    super.initState();
    _homeFuture = _loadHomeData();
  }

  Future<({AssessmentModel? proxima, double? weight, double? imc})>
      _loadHomeData() async {
    final proxima = await _homeService.getProximaAvaliacao();
    final metrics = await _homeService.getLastMetrics();
    return (proxima: proxima, weight: metrics.weight, imc: metrics.imc);
  }

  @override
  Widget build(BuildContext context) {
    final String username =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Usuário';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const HomeAppbar(),
      body: FutureBuilder(
        future: _homeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                HomeWelcomeCard(username: username),
                const SizedBox(height: 16),
                Homemetricsrow(
                  Imc: data?.imc ?? 0.0,
                  WeightPeople: data?.weight ?? 0.0,
                ),
                const SizedBox(height: 24),
                const HomeQuickActions(),
                const SizedBox(height: 24),
                if (data?.proxima != null)
                  HomeNextEvaluationFromAssessment(assessment: data!.proxima!)
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Nenhuma avaliação pendente.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/profissionais');
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/avaliacoes');
            return;
          }
          if (index == 3) {
            Navigator.pushNamed(context, '/perfil');
            return;
          }
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profissionais'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Avaliações'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}