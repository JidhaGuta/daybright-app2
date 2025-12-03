import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  late Future<Quote> futureQuote;
  final QuoteService _quoteService = QuoteService();

  @override
  void initState() {
    super.initState();
    futureQuote = _quoteService.fetchRandomQuote();
  }

  void _refreshQuote() {
    setState(() {
      futureQuote = _quoteService.fetchRandomQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Inspiration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                IconButton(
                  onPressed: _refreshQuote,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Get new quote',
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<Quote>(
              future: futureQuote,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _refreshQuote,
                        child: const Text('Try Again'),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  final quote = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quote text
                      Text(
                        '"${quote.text}"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Author
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '— ${quote.author}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('No quote available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
