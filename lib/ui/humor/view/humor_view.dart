import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emotion_app/ui/humor/view_model/humor_view_model.dart';
import 'package:emotion_app/data/models/humor_model.dart';

class MoodView extends StatelessWidget {
  const MoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MoodViewModel>();
    final noteController = TextEditingController();

    // Emojis + nomes das emoções
    final moodOptions = [
      ("😀", "Muito feliz"),
      ("🙂", "Feliz"),
      ("😐", "Neutro"),
      ("😕", "Confuso"),
      ("😢", "Triste"),
      ("😡", "Irritado"),
      ("🤩", "Animado"),
    ];

    String selectedEmoji = moodOptions.first.$1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TÍTULO ----------
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Diário de Humor",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ),
    // REMOVA o IconButton de refresh aqui
  ],
),

            const SizedBox(height: 16),

            // ---------- LISTA ----------
            if (vm.loadMoods.running)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),

            if (!vm.loadMoods.running && vm.entries.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: vm.entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final MoodEntry entry = vm.entries[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Text(entry.emoji,
                            style: const TextStyle(fontSize: 30)),
                        title: Text(
                          entry.note?.isNotEmpty == true
                              ? entry.note!
                              : "Sem nota",
                        ),
                        subtitle: Text(
                          "${entry.timestamp.day.toString().padLeft(2, '0')}/"
                          "${entry.timestamp.month.toString().padLeft(2, '0')} "
                          "${entry.timestamp.hour.toString().padLeft(2, '0')}:"
                          "${entry.timestamp.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (!vm.loadMoods.running && vm.entries.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sentiment_satisfied_alt,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Nenhum registro ainda",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ---------- ERRO AO REGISTRAR ----------
            if (vm.addMood.error)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "Erro ao registrar humor",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            // ---------- PERGUNTA ----------
            const Text(
              "Como você está se sentindo agora?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // ---------- SELETOR DE EMOJI ----------
            StatefulBuilder(
              builder: (context, setSB) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: moodOptions.map((opt) {
                    final emoji = opt.$1;
                    final label = opt.$2;
                    final isSelected = emoji == selectedEmoji;

                    return GestureDetector(
                      onTap: () => setSB(() => selectedEmoji = emoji),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.indigo
                                    : Colors.grey.shade400,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 32)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? Colors.indigo
                                  : Colors.grey.shade600,
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),

            // ---------- CAIXA DE TEXTO ----------
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Nota opcional...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 10),

            // ---------- BOTÃO ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: vm.addMood.running
                    ? null
                    : () {
                        vm.addMood.execute((
                          emoji: selectedEmoji,
                          note: noteController.text,
                        ));
                        noteController.clear();
                      },
                icon: vm.addMood.running
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_reaction),
                label: const Text("Registrar Humor"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
