// lib/ui/mood/tips_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/mood/tipsViewModel.dart';

class TipsView extends StatelessWidget {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TipsViewModel(
        repository: context.read(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas de Bem-Estar"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<TipsViewModel>().refreshTips();
              },
              tooltip: "Atualizar dicas",
            ),
          ],
        ),
        body: Consumer<TipsViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  _buildHeader(vm),
                  
                  const SizedBox(height: 20),
                  
                  // Lista de dicas
                  Expanded(
                    child: _buildTipsList(vm),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(TipsViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  "Dicas Personalizadas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              vm.hasData 
                  ? "Baseado nos seus registros recentes de humor"
                  : "Registre seu humor para receber dicas personalizadas",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsList(TipsViewModel vm) {
    if (vm.tips.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.separated(
      itemCount: vm.tips.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tip = vm.tips[index];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(Tip tip) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: tip.category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tip.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Conteúdo principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoria
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tip.category.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tip.category.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tip.category.color,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Título
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Descrição
                      Text(
                        tip.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Informações adicionais
            if (tip.duration != null || tip.resource != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (tip.duration != null) ...[
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        tip.duration!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (tip.resource != null) ...[
                      const Icon(Icons.link, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tip.resource!,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}