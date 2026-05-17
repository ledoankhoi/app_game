import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn chữ dòng chữ Debug ở góc app
      home: Scaffold(
        // AppBar: Thanh tiêu đề phía trên cùng của app
        appBar: AppBar(
          title: const Text('Ứng dụng đầu tay'),
          backgroundColor: Colors.blue,
        ),
        // Body: Phần nội dung chính của màn hình
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chào mừngvới Flutter!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20), // Tạo một khoảng trống cách ra
              // ElevatedButton: Nút bấm
              ElevatedButton(
                onPressed: () {
                  // Hành động khi bấm nút sẽ viết ở đây
                  print('Bạn vừa bấm vào nút!');
                },
                child: const Text('Bấm vào tôi đi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
