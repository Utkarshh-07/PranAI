import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaitriTipCard extends StatelessWidget {
  const MaitriTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
      "Take 5 deep breaths when feeling anxious.",
      "Drink water - dehydration affects mood!",
      "20 minutes of sunlight boosts serotonin.",
      "Talk to someone when feeling overwhelmed.",
      "Break big tasks into smaller steps.",
    ];
    
    final randomTip = tips[DateTime.now().day % tips.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Color(0xFFF9AA33)),
              const SizedBox(width: 10),
              Text(
                'Maitri Tip of the Day',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A6572),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFF3CD)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        randomTip,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF4A6572),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Maitri = Loving-Kindness in Sanskrit',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9AA33).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Color(0xFFF9AA33),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('More tips coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: Text(
                  'More Tips',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tip shared successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.share, size: 16),
                label: Text(
                  'Share',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}