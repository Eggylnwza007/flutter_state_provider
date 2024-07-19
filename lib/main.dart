import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int total = 0;
  Map<String, int> prices = {
    "iPad": 19000,
    "iPad mini": 23000,
    "iPad Air": 29000,
    "iPad Pro": 39000
  };
  Map<String, int> counts = {
    "iPad": 0,
    "iPad mini": 0,
    "iPad Air": 0,
    "iPad Pro": 0
  };

  void updateTotal() {
    setState(() {
      total = counts.entries
          .map((entry) => prices[entry.key]! * entry.value)
          .reduce((a, b) => a + b);
    });
  }

  void incrementNumber(String item, int increment) {
    setState(() {
      counts[item] = (counts[item]! + increment).clamp(0, double.infinity).toInt();
    });
    updateTotal();
  }

  void clearCounts() {
    setState(() {
      counts.updateAll((key, value) => 0);
      total = 0;
    });
  }

  String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Cart"),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: prices.keys.map((item) {
                  return ShoppingItem(
                    title: item,
                    price: prices[item]!,
                    count: counts[item]!,
                    onIncrement: (increment) => incrementNumber(item, increment),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "${formatNumber(total)}฿",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: clearCounts,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepOrange),
                  child: const Text("Clear"),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final String title;
  final int price;
  final int count;
  final Function(int increment) onIncrement;

  ShoppingItem({
    required this.title,
    required this.price,
    required this.count,
    required this.onIncrement,
  });

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 28),
              ),
              Text("${NumberFormat('#,###').format(widget.price)}฿"),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                widget.onIncrement(-1);
              },
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.count.toString(),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                widget.onIncrement(1);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
