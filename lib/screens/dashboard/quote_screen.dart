import 'package:flutter/material.dart';
import '../../services/quote_service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  String quote = "Press the button to get a motivational quote.";
  String author = "";
  bool loading = false;
  String errorMessage = "";
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> fetchQuote() async {
    setState(() {
      loading = true;
      errorMessage = "";
    });

    try {
      print("Fetching quote..."); // Debug print
      final quoteObj = await _quoteService.fetchRandomQuote();
      print("Quote fetched: ${quoteObj.text}"); // Debug print

      setState(() {
        quote = quoteObj.text;
        author = "- ${quoteObj.author}";
      });
    } catch (e) {
      print("Error: $e"); // Debug print
      setState(() {
        errorMessage = e.toString();
        quote = "Error fetching quote. Please try again.";
        author = "";
      });

      // Show error message in the UI instead of SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text("Daily Motivation"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error message display
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(
                        "Network Error",
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Check your internet connection",
                        style: TextStyle(color: Colors.red.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              // Quote Card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.format_quote,
                                size: 40,
                                color: Colors.blue.shade200,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                quote,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (author.isNotEmpty)
                                Text(
                                  author,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Buttons section
              Column(
                children: [
                  if (loading)
                    Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        const Text('Fetching quote...'),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: fetchQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Get New Quote"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                    ),

                  const SizedBox(height: 20),

                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back to Dashboard"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                  ),

                  // Debug button
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        quote =
                            "The only way to do great work is to love what you do.";
                        author = "- Steve Jobs";
                        errorMessage = "";
                      });
                    },
                    child: const Text('Use Test Quote'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
